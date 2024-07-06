#!/usr/bin/env bash

# Convert markdown files to HTML

runFolder=$(pwd)

for inputFile in "$@";
do

  echo "Generating \"$outputFile\""

  # replace file extension in internal links (e.g. [link](file.md) -> [link](file.html))
  sed -E 's#\[(.*?)\]\((.+?)\.md\)#[\1](\2.html)#g' "$inputFile" > /dev/shm/parsedContent.md

  outputFile=${inputFile%.*}.html

  pandoc <(./bin/parseImport.sh /dev/shm/parsedContent.md) \
    -o "$outputFile" \
    -f markdown \
    --pdf-engine wkhtmltopdf \
    --pdf-engine-opt=--enable-local-file-access \
    --resource-path=$(dirname "$inputFile") \
    --css $runFolder/content/style.css \
    --self-contained \
    --metadata pagetitle="`sed -n 's/^# //p' "$inputFile" | head -n 1`" \
    
done