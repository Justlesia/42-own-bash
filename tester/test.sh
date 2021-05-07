# MINISHELL-TESTER

RESET="\033[0m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

BOLDBLACK="\033[1m\033[30m"
BOLDRED="\033[1m\033[31m"
BOLDGREEN="\033[1m\033[32m"
BOLDYELLOW="\033[1m\033[33m"
BOLDBLUE="\033[1m\033[34m"
BOLDMAGENTA="\033[1m\033[35m"
BOLDCYAN="\033[1m\033[36m"
BOLDWHITE="\033[1m\033[37m"

# Compile and set executable rights
make -C ../ > /dev/null
cp ../minishell .
chmod 755 minishell
ok=0
all=0
function exec_test()
{
	TEST1=`./minishell -c "$@" 2>/dev/null`
	ES_1=$?
	TEST2=`bash -c "$@" 2>/dev/null`
	ES_2=$?
	all=$((all + 1))
  if [ "$all" -lt 10 ]; then
    printf " "
  fi
  printf "$all."
	if [ "$TEST1" == "$TEST2" ] && [ "$ES_1" == "$ES_2" ]; then
		printf " $BOLDGREEN%s$RESET" "✓ "
		ok=$((ok + 1))
	else
		printf " $BOLDRED%s$RESET" "✗ "
	fi
	printf "$CYAN \"$@\" $RESET"
	if [ "$TEST1" != "$TEST2" ]; then
		echo
		echo
		printf $BOLDRED"Your output : \n%.20s\n$BOLDRED$TEST1\n%.20s$RESET\n" "-----------------------------------------" "-----------------------------------------"
		printf $BOLDGREEN"Expected output : \n%.20s\n$BOLDGREEN$TEST2\n%.20s$RESET\n" "-----------------------------------------" "-----------------------------------------"
	fi
	if [ "$ES_1" != "$ES_2" ]; then
		echo
		echo
		printf $BOLDRED"Your exit status : $BOLDRED$ES_1$RESET\n"
		printf $BOLDGREEN"Expected exit status : $BOLDGREEN$ES_2$RESET\n"
	fi
	echo
	sleep 0.1
}

printf "$BOLDMAGENTA __  __ _____ _   _ _____  _____ _    _ ______ _      _      \n"
printf "|  \/  |_   _| \ | |_   _|/ ____| |  | |  ____| |    | |     \n"
printf "| \  / | | | |  \| | | | | (___ | |__| | |__  | |    | |     \n"
printf "| |\/| | | | | . \` | | |  \___ \|  __  |  __| | |    | |     \n"
printf "| |  | |_| |_| |\  |_| |_ ____) | |  | | |____| |____| |____ \n"
printf "|_|  |_|_____|_| \_|_____|_____/|_|  |_|______|______|______|\n$RESET"
echo

exec_test '/bin/ls'
exec_test 'bin/ls'
exec_test 'bin/ls'
exec_test 'bin/ls/'
exec_test 'ls/'
exec_test '/ls'
exec_test './ls'
exec_test '../ls'
exec_test '/..'
touch f1
exec_test 'f1/'
exec_test '/f1'
exec_test './f1'
exec_test '../f1'
exec_test 'bu/f1'
rm f1
mkdir f1
exec_test 'f1/'
exec_test '/f1'
exec_test './f1'
exec_test '../f1'
exec_test 'bu/f1'
rm -rf f1
exec_test '/bin/ls -l'
exec_test '/bin/ls --l'
exec_test '/bin/ls -l-a'
exec_test '/bin/ls -l -a'
exec_test '/ls -l'
exec_test 'ls --l'
exec_test 'ls -l-a'
exec_test 'ls -l -a'
exec_test '\l\s \-l \-a'
exec_test 'ls \\\>| wc'
exec_test 'ls \\>| wc'
exec_test 'ls \>| wc'
exec_test 'ls >| wc'
exec_test "ls '>|' wc"
exec_test "ls '>\\|""' wc"
rm wc
exec_test 'ls "$\P\A\T\H"'
exec_test "ls '$\P\A\T\H'"
exec_test 'ls $\P\A\T\H'
exec_test '\l\s'
exec_test 'l\s'
exec_test 'ls\'
exec_test ' ls\ '
exec_test '\  \  \\'
exec_test 'ls \; \|'
exec_test 'ls \; ; grep bla'
exec_test 'ls \; ; | grep bla'
exec_test 'ls;'
exec_test ';ls'
exec_test 'ls;;;'
exec_test 'ls ";" -la'
exec_test "ls -l '-'a"
exec_test "'l''s'"
exec_test "ls ''"
exec_test '    ls;;   ;     '
exec_test 'ls | grep bla'
exec_test 'ls | grep min'
exec_test 'blabla | grep min | grep shell'
exec_test 'blabla | ls | grep min'
exec_test 'ls | blabla | grep min'
exec_test 'ls | grep min | blabla'
exec_test 'grep | ls'
exec_test 'ls | grep'
exec_test 'ls | blabla | wc'
exec_test 'ls -la | grep min | grep shell | wc'
exec_test 'ls -la | grep min | grep shell | wc | blabla'
exec_test 'ls -la wrong | grep min | grep shell | wc | blabla'
exec_test 'ls -la wrong | grep min | grep shell | wc'
exec_test 'grep min | wc | ls -la wrong'
exec_test 'grep | wc | ls -la wrong'
exec_test 'grep | ls -la wrong | wc'
exec_test '|ls'
exec_test '| ls'
exec_test 'ls     |'
exec_test '     ls     |'
exec_test '   |    ls     |'
exec_test 'ls|||||||'
exec_test      'ls|||||||'
exec_test   'ls|||||||     '
exec_test   'ls||  ||||  |     '
exec_test   'ls||  ||>||  |     '
exec_test     'ls||||  pwd|||     '
exec_test 'ls|   ls  |  |    '
exec_test 'ls > fil1.txt; blabla ||| ; wc'
exec_test 'ls > fil1.txt; cat fil1.txt'
exec_test '|>|'
exec_test '|>|l s'
exec_test 'ls>file1.txt'
exec_test 'ls>file1.txt <file2.txt -la'
exec_test 'ls>file2.txt -la'
exec_test 'ls><file1.txt'
exec_test 'ls<>file1.txt'
exec_test 'ls>file1.txt -l a<file1.txt'
exec_test 'ls<>'
exec_test '< ls'
exec_test '> ls'
exec_test '>'
exec_test '<'
exec_test '>\>'
exec_test '> file1.txt ls'
exec_test "ls > 'pwd'"\"""
exec_test 'ls >\|;wc'
exec_test 'ls >\| pwd'
exec_test 'ls >| pwd'
exec_test 'ls >| | pwd'
exec_test 'ls ; ls>  " \"| p " bla' # all good, but tester may show error, delete file after first run
exec_test 'ls ; ls>  " \"| p "' # same
exec_test 'ls>  " \| p "'
exec_test "ls>' | p '"
exec_test 'ls> | p'
exec_test 'ls>|'
exec_test 'ls >|||pwd$'
exec_test 'ls >|\|\|pwd$'
exec_test 'ls > $$$$\\'
exec_test 'ls <| wc'
exec_test '> f1 ls bla'

echo ==============================================
echo $ok / $all