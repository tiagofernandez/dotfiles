#!/usr/bin/env bash
set -euo pipefail

# ### How to Use

#   • After installing to ~/.local/bin, run:
#     rename_photos
#
#   • Run directly in the current folder:
#     ./rename_photos.sh

#   • Run in preview mode (dry run without renaming anything):
#     ./rename_photos.sh --dry-run
#     # or
#     ./rename_photos.sh -n

#   • Run on a different folder:
#     ./rename_photos.sh /path/to/other/folder

#   • Show help:
#     ./rename_photos.sh --help

#   ──────
#   ### What It Does

#   1. Self-contained: Embeds the exact ExifTool composite tag logic into a temporary configuration file during execution and cleans up automatically upon exit.
#   2. Exact hierarchy:
#       • Capture date: DateTimeOriginal for images, CreateDate for videos.
#       • 13-digit Unix ms timestamp: Converted to local time yyyyMMdd-HHmmss.
#       • Pre-existing date-time: Preserves yyyyMMdd-HHmmss if already present in the filename.
#       • Date-only: Extracts yyyyMMdd and defaults the time to 000000.
#       • Fallback: Uses FileModifyDate if no other date source is available.
#   3. Collision handling: Appends hyphenated copy numbers (%-c, e.g. -1, -2).
#   4. Idempotent: Safe to run on already renamed files without corrupting names or resetting times.

DRY_RUN=false
TARGET_DIR="."

for arg in "$@"; do
    case "$arg" in
        -n|--dry-run)
            DRY_RUN=true
            ;;
        -h|--help)
            echo "Usage: $(basename "$0" .sh) [-n|--dry-run] [DIRECTORY]"
            echo ""
            echo "Renames images and videos using ExifTool based on:"
            echo "  1. Capture date (DateTimeOriginal for images, CreateDate for videos)"
            echo "  2. 13-digit Unix millisecond epoch in filename -> exact local time"
            echo "  3. Pre-existing date-time in filename (yyyyMMdd-HHmmss)"
            echo "  4. Date-only in filename (yyyyMMdd) -> default time 000000"
            echo "  5. File modification date as final fallback"
            echo ""
            echo "Format: yyyyMMdd-HHmmss.{ext} (prefixes dropped, hyphenated copy numbers on collision)"
            exit 0
            ;;
        *)
            TARGET_DIR="$arg"
            ;;
    esac
done

if ! command -v exiftool >/dev/null 2>&1; then
    echo "Error: exiftool is not installed or not in PATH." >&2
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist." >&2
    exit 1
fi

TMP_CONFIG=$(mktemp /tmp/exiftool_rename.XXXXXX.config)
trap 'rm -f "$TMP_CONFIG"' EXIT

cat << 'CONFIG_EOF' > "$TMP_CONFIG"
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::Composite' => {
        NewFileName => {
            Desire => {
                0 => 'DateTimeOriginal',
                1 => 'CreateDate',
                2 => 'FileName',
                3 => 'FileModifyDate',
                4 => 'MIMEType',
            },
            ValueConv => q{
                use POSIX qw(strftime);
                my ($dto, $cd, $fn, $fmd, $mime) = @val;
                my $is_video = ($mime && $mime =~ /^video\//) ? 1 : 0;
                
                my $target_date;
                # 1. Capture date: DateTimeOriginal for images, CreateDate for videos
                if ($is_video) {
                    $target_date = $cd if ($cd && $cd !~ /^0000:00:00/);
                } else {
                    $target_date = $dto if ($dto && $dto !~ /^0000:00:00/);
                }
                
                if (defined $target_date && $target_date =~ /^(\d{4})[:\-](\d{2})[:\-](\d{2})\s+(\d{2})[:\-](\d{2})[:\-](\d{2})/) {
                    return "$1$2$3-$4$5$6";
                }
                
                # 2. Fallback: 13-digit Unix epoch ms timestamp (e.g. 1790673898118) -> exact local time
                if ($fn =~ /(?:^|[^0-9])(\d{13})(?:[^0-9]|$)/) {
                    return strftime("%Y%m%d-%H%M%S", localtime(int($1 / 1000)));
                }
                
                # 3. Fallback: Filename already has yyyyMMdd-HHmmss or yyyyMMdd_HHmmss
                if ($fn =~ /(?:^|[^0-9])(20\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))[-_]((?:[01]\d|2[0-3])[0-5]\d[0-5]\d)(?:[^0-9]|$)/) {
                    return "$1-$2";
                }
                
                # 4. Fallback: yyyyMMdd in filename (e.g. IMG-20260926-WA0027.jpg) -> default time 000000
                if ($fn =~ /(?:^|[^0-9])(20\d{2})(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])(?:[^0-9]|$)/) {
                    return "$1$2$3-000000";
                }
                
                # 5. Fallback: FileModifyDate
                if ($fmd && $fmd =~ /^(\d{4})[:\-](\d{2})[:\-](\d{2})\s+(\d{2})[:\-](\d{2})[:\-](\d{2})/) {
                    return "$1$2$3-$4$5$6";
                }
                return undef;
            },
        },
    },
);
1;
CONFIG_EOF

TAG_TARGET="FileName"
if [ "$DRY_RUN" = true ]; then
    TAG_TARGET="TestName"
    echo "Running in DRY RUN mode (no files will be renamed)..."
fi

RENAME_ARG="-${TAG_TARGET}<\${NewFileName}%-c.%e"
exiftool -config "$TMP_CONFIG" "$RENAME_ARG" "$TARGET_DIR"
