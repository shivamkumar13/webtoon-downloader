#! /bin/bash

# to change permission
# chmod +X <filename.sh>

#download from manhwa
if [ $# -ne 3 ]; then
	echo "<Parent URL> <Name of Comic> <Number of Chapters>"
	echo "All three space separated"
	echo "eg-> https://toonily.com/webtoon/ the-boy-who-slept 3"
	exit -1
fi

echo $1 $2 $3

curl=$(which curl)
outfile="url.txt"
regex="lazyload effect-fade"
manga_id="manga_5bf3793e73db1"
url=$1
manga_name=$2
last_chapter=$3
chapter_number=0
chapter_array={01..$end_chapter}

#--------------------------------------------------------------------------------------------------------------

function find_url_list(){
	$curl -s -o  $outfile $chapter_url
	grep -h -e "manga_" $outfile | sed -n -e 's/" class.*//p'| sed -e 's/\t//g' > temp.txt
	cp temp.txt $outfile
	rm temp.txt
}

function download_files(){
	wget -qNi $outfile
}
#--------------------------------------------------------------------------------------------------------------
function download_chapter(){
	download_files
}

function doing_chapters(){
		chapter_name="Chapter-$(printf "%02d" $c)"
		chapter_number="chapter-$c"
		mkdir $chapter_name
		cd $chapter_name
		chapter_url="${url}$manga_name/${chapter_number,}/"
		printf "\n\t%s:\t%s" "$chapter_name" "$chapter_url"
		find_url_list
		download_chapter # Download all files in url.txt
		rm $outfile
		cd ..
}
function doing_last_chapter(){
	chapter_name="Chapter-$(printf "%02d" $c)"
		chapter_number="chapter-$c"
		end="-end"
		mkdir $chapter_name$end
		cd $chapter_name$end
		chapter_url="${url}$manga_name/${chapter_number,}${end}/"
		printf "\n\t%s:\t%s" "$chapter_name" "$chapter_url"
		find_url_list
		download_chapter # Download all files in url.txt
		rm $outfile
		cd ..
}

function chapters(){
	c=1
	
	for (( c=1; c<$last_chapter; c++ ))
	do
		doing_chapters
	done
	
		doing_last_chapter
	c=1

}

function parent_folder(){
	echo
	echo "========================================================================"
	echo "                  $manga_name"
	echo "========================================================================"
	mkdir $manga_name
	cd $manga_name
	chapters
	cd ..
}
#--------------------------------------------------------------------------------------------------------------
function main(){
	parent_folder
}
#--------------------------------------------------------------------------------------------------------------

# function check_errors(){
# 	[ $? -ne 0 ] && echo "Error Downloading page...." && exit -1
# }


###########################
#         MAIN            #
###########################
main
echo ""
echo ""
echo "------------------------------------------------------------------------"
printf "%s\t%s Files" "$(du -hs $manga_name)" "$(find ./$manga_name -type f | wc -l)"
echo
echo "========================================================================"




# dump_webpage
# find_url

# download_files


#END

#to download in current folder
# wget "https://cdn.manhwa.club/data/manga_5bf3793e73db1/288836c7bd3a02b0a2e7dd9b61860f1f/28_stacked.jpg"