#!/bin/bash

IGNORE_KEYWORDS=(".nojekyll" "tmp")

function should_ignore() {
  local name=$1
  
  for keyword in "${IGNORE_KEYWORDS[@]}"; do
    if [[ "$name" == *"$keyword"* ]]; then
      return 0
    fi
  done
  
  return 1
}

function generate_html() {
  local dir=$1
  local relative_path=$2
  local html_file="${dir}/index.html"
  local template="$(dirname "$0")/index-template.html"
  
  local content_file=$(mktemp)
  
  if [ -n "$relative_path" ]; then
    echo "<tr>
      <td><a href=\"../index.html\" class=\"dir\">..</a></td>
      <td class=\"size\">-</td>
      <td class=\"date\">-</td>
    </tr>" >> "$content_file"
  fi
  
  find "$dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r subdir; do
    dir_name=$(basename "$subdir")
    
    if should_ignore "$dir_name"; then
      continue
    fi
    
    echo "<tr>
      <td><a href=\"${dir_name}/index.html\" class=\"dir\">${dir_name}/</a></td>
      <td class=\"size\">-</td>
      <td class=\"date\">-</td>
    </tr>" >> "$content_file"
    
    if [ -n "$relative_path" ]; then
      generate_html "$subdir" "${relative_path}/${dir_name}"
    else
      generate_html "$subdir" "${dir_name}"
    fi
  done
  
  find "$dir" -mindepth 1 -maxdepth 1 -type f -not -name "index.html" | sort | while read -r file; do
    file_name=$(basename "$file")
    
    if should_ignore "$file_name"; then
      continue
    fi
    
    size=$(du -h "$file" | cut -f1)
    date=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
    
    echo "<tr>
      <td><a href=\"${file_name}\">${file_name}</a></td>
      <td class=\"size\">${size}</td>
      <td class=\"date\">${date}</td>
    </tr>" >> "$content_file"
  done
  
  local content=$(cat "$content_file")
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  
  cp "$template" "$html_file.tmp"
  sed -i "s|{{TITLE}}|InfinitySubstance 软件包索引|g" "$html_file.tmp"
  sed -i "s|{{PATH}}|/${relative_path}|g" "$html_file.tmp"
  sed -i "s|{{TIMESTAMP}}|${timestamp}|g" "$html_file.tmp"
  sed -i "s|{{REPO}}|${GITHUB_REPOSITORY}|g" "$html_file.tmp"
  
  perl -i -pe 'BEGIN{undef $/;} s/\{\{CONTENT\}\}/'"$(sed 's/[\/&]/\\&/g' <<< "$content")"'/smg' "$html_file.tmp"
  
  mv "$html_file.tmp" "$html_file"
  
  rm "$content_file"
}

if [ $# -eq 0 ]; then
  echo "用法: $0 <目录>"
  exit 1
fi

root_dir="$1"
generate_html "$root_dir" ""
echo "索引文件已生成"
