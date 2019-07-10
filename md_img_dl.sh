#!/bin/bash
PROGNAME=$(basename $0)
ISSELF=false
SOURCE_FILE=""
c_dir=""

usage () {
    echo "$PROGNAME: usage: $PROGNAME [-s | --self] [-f file | --file file]
    [-s | --self] create dir with same name for each file , default create dir name backup in work dir 
    [-f file | --file file] soure file , single file or a dir
    "
    return
}

filter_download(){
    grep -oE "\!\[.*?\]\(https?:\/\/.*?\)" $1 | sed  -E  "s/(\!\[.*\]\()(https?:\/\/.+)(.*\))/\2/gi" |xargs  wget -cN -P $2
}

parse_file (){
    if [[ -f $1 ]];then
        file_name=$(basename $1) 
        if $ISSELF;then
            c_dir=$(dirname $1)'/'${file_name%.*}
            if  filter_download $1 $c_dir ;then
                echo $1
            fi
        else
            if filter_download $1 backup'/'${file_name%.*};then
                echo $1
            fi
            
        fi
    else
        echo "wrong file path"
        return 1
    fi
}

parse_dir(){
    for file in `ls $1`
    do
        filePath=$1"/"$file
        if [[ -d $filePath ]] ;then
            parse_dir $filePath
        elif [[ -f $filePath ]]&& [[ ${filePath##*.} =~ [Mm][Dd] ]];then
            parse_file $filePath
        fi
    done
}

## 读取参数
while [[ -n $1 ]]; do
    case $1 in
    -s | --self)    ISSELF=true
    ;;
    -f | --file)    
                    shift
                    SOURCE_FILE="$1"
    ;;
    -h | --help)    usage >&2
                    exit 0
    ;;
    *)              usage >&2
                    exit 1
    ;;
    esac
    shift
done
if [[ -z $SOURCE_FILE ]];then
    SOURCE_FILE=.
fi
if [[ -f $SOURCE_FILE ]];then
    parse_file $SOURCE_FILE
elif [[ -d $SOURCE_FILE ]];then
    parse_dir $SOURCE_FILE
fi
    
    