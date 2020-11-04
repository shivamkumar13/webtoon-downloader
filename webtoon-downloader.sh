#! /bin/bash

# to change permission
# chmod +X <filename.sh>

#download from manhwa

curl=$(which curl)
outfile="url.txt"
regex="lazyload effect-fade"
manga_id="manga_5ef28dfd223b7"
url=$1
manga_name=$2
last_chapter=$3
chapter_number=0
chapter_array={01..$end_chapter}

if [ $# -ne 3 ]; then
	echo ""
	echo "<Parent URL> <Name of Comic> <Number of Chapters>"
	echo "OR"
	echo "bash webtoon-downloader.sh <Parent URL> <Name of Comic> <Number of Chapters>"
	echo ""
	echo "All three space separated"
	echo "eg-> https://toonily.com/webtoon/ the-boy-who-slept 3"
	echo ""
	echo "Please check manga_id and effect class name"
	echo -e "Current manga_id \t:$manga_id"
	echo -e "Current effect class \t:$regex"
	echo ""
	echo "check urls/ manga id by typing"
	echo "curl -s -o page_source.txt <chapter_url>"
	echo "grep -h -e \"manga_\" page_source.txt | sed -n -e 's/\" class.*//p'| sed 's/^.*\(http.*jpg\).*$/\1/' > url_list.txt"
	echo ""
	echo "check url_list, it should contain url in form of"
	echo "https://toonily.com/wp-content/uploads/WP-manga/data/manga_5ef28dfd223b7/c86ccd727570a39e3bc673de1a6e2dc4/002.jpg"

	exit -1
fi

echo $1 $2 $3



#--------------------------------------------------------------------------------------------------------------

function find_url_list(){
	# curl chapter url source code
	$curl -s -o  $outfile $chapter_url
	# extract url
	grep -h -e "manga_" $outfile | sed -n -e 's/" class.*//p'| sed 's/^.*\(http.*jpg\).*$/\1/' > temp.txt
	cp temp.txt $outfile
	rm temp.txt
}

function download_files(){
	wget -qNi $outfile --show-progress --progress=bar:force 2>&1
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

		
		no_of_url_in_outfile="$(cat $outfile | wc -l)"
		echo ""
		printf " \t URL:%s" "$no_of_url_in_outfile"
		rm $outfile
		printf " Files:%s" "$(ls | wc -l)"
		printf " Completed:%s" "$chapter_name"
		echo ""
		echo "."
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



#---------------------------------------------------------------------------------------------------

# Renaming every first file of chapter with trailing chapter name eg-> 01.jpg 01-Chapter-19.jpg
function renaming(){
	chapter_name="Chapter-$(printf "%02d" $c)"
	cd $chapter_name
	[[ -f 01.jpg ]] && mv 01.jpg 01-$chapter_name.jpg
	[[ -f 001.jpg ]] && mv 001.jpg 001-$chapter_name.jpg
	cd ..
}


function chapters_renaming(){
	###########################
#         RENAMING        #
###########################
echo "########### RENAMING ###############"
echo "This is done to have a Bookmark of chapters from Images"
echo "if file 01.jpg OR 001.jpg exist chaged to 01-Chapter-<number>.jpg OR 001-Chapter-<number>.jpg"
chapters_renaming

	c=1
	cd $manga_name 
	for (( c=1; c<=$last_chapter; c++ ))
	do
		renaming
	done
	cd ..
}

