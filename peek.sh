

first_lines=$1
last_lines=$2
input_file=$3


head -n "$first_lines" "$input_file"

echo "..."

tail -n "$last_lines" "$input_file"

