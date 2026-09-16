#!/bin/bash

# take exactly one command-line argument, which is the name of a C source file
filename="$1"

# verify the file exists
if [ -e "$filename" ]; then
	echo "File exists."
else
	echo "Error: file does not exist"
	exit 1
fi 

# verify if it is a c file
case "$filename" in
	*.c)
		echo "This is a c file"
		;;
	*)
		echo "Error: this is not a c file"
		exit 1
		;;
esac

# extract owner of file
owner=$(ls -l "$filename" | awk '{print $3}')

# extract last modified date and time
last_modified=$(ls -l "$filename" | awk '{print $7, $8, $9}')

# create a temporary file
temp_file=$(mktemp)

# add header to temporary file
cat << _EOF_ > "$temp_file"
/**
 * File name: $filename
 * Owner: $owner
 * Last Modified On: $last_modified
 */
_EOF_

# add original file to the end of temporary file
cat "$filename" >> "$temp_file"

# replace original file with content from the temporary file, delete temp file
mv "$temp_file" "$filename"
