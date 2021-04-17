#/usr/bin/env bash

cd $(dirname $0)

### Script variables
_script_dir="${1}"
_version_file="${2}"/version.txt

### Pick current Version
_version=$(cut -d':' -f2 $_version_file|xargs)
_isGreat=false

### Sort filenames in number order and save in temp file
ls "${_script_dir}" |sort -n > tmp.lst

while read line
do
  ### Trim suffix of filename 
  _max=${line%%[.| ][[:alpha:]]*} 

  ### execute scripts where prefix is greater than current version 
  if [[ $_version -lt $_max ]]
  then
    _isGreat=true
    bash "${_script_dir}"/"${line}"
  fi
done < tmp.lst

### Finally update version number if it is greater than current version

$_isGreat && sed -i "s/[[:digit:]].*/$_max/" $_version_file
