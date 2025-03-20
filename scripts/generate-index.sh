#!/bin/bash

function generate_html() {
  local dir=$1
  local relative_path=$2
  local html_file="${dir}/index.html"
  local template="$(dirname "$0")/index-template.html"
  
  local content=""
  
  if [ -n "$relative_path" ]; then
    content+="<tr>
      <td><a href=\"../index.html\" class=\"dir\">..</a></td>
      <td class=\"size\">-</td>
      <td class=\"date\">-</td>
    </tr>"
  fi
  
  find "$dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r subdir; do
    dir_name=$(basename "$subdir")
    content+="<tr>
      <td><a href=\"${dir_name}/index.html\" class=\"dir\">${dir_name}/</a></td>
      <td class=\"size\">-</td>
      <td class=\"date\">-</td>
    </tr>"
    
    if [ -n "$relative_path" ]; then
      generate_html "$subdir" "${relative_path}/${dir_name}"
    else
      generate_html "$subdir" "${dir_name}"
    fi
  done
  
  find "$dir" -mindepth 1 -maxdepth 1 -type f -not -name "index.html" | sort | while read -r file; do
    file_name=$(basename "$file")
    size=$(du -h "$file" | cut -f1)
    date=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
    content+="<tr>
      <td><a href=\"${file_name}\">${file_name}</a></td>
      <td class=\"size\">${size}</td>
      <td class=\"date\">${date}</td>
    </tr>"
  done
  
  sed -e "s|{{TITLE}}|InfinitySubstance 软件包索引|g" \
      -e "s|{{PATH}}|/${relative_path}|g" \
      -e "s|{{CONTENT}}|${content}|g" \
      -e "s|{{TIMESTAMP}}|$(date "+%Y-%m-%d %H:%M:%S")|g" \
      -e "s|{{REPO}}|${GITHUB_REPOSITORY}|g" \
      "$template" > "$html_file"
}

if [ $# -eq 0 ]; then
  echo "用法: $0 <目录>"
  exit 1
fi

root_dir="$1"
generate_html "$root_dir" ""
echo "索引文件已生成"
