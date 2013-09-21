#!/bin/bash
# Скрипту можно передать аргумент - число, до которого проверять числа
ARG=100000
TESTFILE="result.log"
TIME_ARGS="\t1. Всего затрачено времени:\t%E
\t2. Процесс в режиме ядра:\t%S
\t3. Процесс в режиме пользователя:\t%U
\t4. Процент работы CPU:\t%P
\t5. Максимальный размер процесса в течении выполнения (в Кб):\t%M
\t6. Переключений контекста из-за истечения выделенного время:\t%c
\t7. Переключений контекста из-за ожидания операций ввода-вывода:\t%w"
if [ $1 ]
then
	ARG=$1
fi
PREFIX_DIR=`dirname $0`
# 1 - язык программирования/папка, в которой находится исходник
# 2 - имя файла-исходника
# 3 - параметры,которые передаются запускемому скрипту/программе
# 4 - для компилируемых языков: имя собираемого бинарного файла
function get_language_cmd(){
	cmd_string=`grep -Eom1 "${1}=\"[^\"]*\"" ${PREFIX_DIR}/languages.list`
	cmd_string=${cmd_string//!SOURCE_FILE!/${2}}
	cmd_string=${cmd_string//!EXEC_FILE!/${4}}
	cmd_string=${cmd_string#${1}=\"}
	cmd_string=${cmd_string%\"}
	if [ $4 ]
	then
		cmd_string="$cmd_string"
		run_string="${4} ${3}"
	else
		cmd_string="$cmd_string ${3}"
	fi

}

get_language_cmd c ${PREFIX_DIR}/compiled/c/normal.c ${ARG} ./test
$cmd_string
$run_string > result.log
echo -e "\nБудут выполнены проверки всех чисел до ${ARG}\n"

function prepare(){
	IFS='/' read -a input
	HINUM=0
	MIDNUM=0
	LOWNUM=0
	while [ $input ]
	do
		if [ ${oldinput[1]} -a ${oldinput[1]} != ${input[1]} ]
		then
			HINUM=$((HINUM+1))
			MIDNUM=0
			LOWNUM=0
			echo -e "$HINUM.\t${input[1]}:"
		fi
		
		if [ ${oldinput[2]} -a ${oldinput[2]} != ${input[2]} ]
		then
			MIDNUM=$((MIDNUM+1))
			LOWNUM=0
			echo -e "$HINUM.$MIDNUM.\t${input[2]}:"
		fi
		
		if [ ${oldinput[3]} -a ${oldinput[3]} != ${input[3]} ]
		then
			LOWNUM=$((LOWNUM+1))
			echo -e "$HINUM.$MIDNUM.$LOWNUM.\t${input[3]}:"

		fi

		if [ ${input[1]} == "interpreted" ]
		then
			get_language_cmd ${input[2]} "${PREFIX_DIR}/${input[1]}/${input[2]}/${input[3]}" ${ARG}
			/usr/bin/time --format="${TIME_ARGS}" $cmd_string | diff - $TESTFILE
			if [ $? -eq 0 ]
			then
				echo "Проверка stdout: ОК"
			else
				echo -e "\n\n-----------Проверка stdout: Ошибка!!!-----------\nIn file: ${PREFIX_DIR}/${input[1]}/${input[2]}/${input[3]}\n"
			fi
		fi

		if [ ${input[1]} == "compiled" ]
		then
			get_language_cmd ${input[2]} "${PREFIX_DIR}/${input[1]}/${input[2]}/${input[3]}" ${ARG} "./test"
			$cmd_string
			/usr/bin/time --format="${TIME_ARGS}" $run_string | diff - $TESTFILE
			rm ./test
			if [ $? -eq 0 ]
			then
				echo "Output: OK"
			else
				echo -e "\n\n-----------Output: WRONG!!!-----------\nIn file: ${PREFIX_DIR}/${input[1]}/${input[2]}/${input[3]}\n"
			fi
		fi
		oldinput=(${input[*]})
		IFS='/' read -a input
	done
}

function check(){
	read cmd
	while [ $cmd ]
	do
		echo -n "Поиск $cmd:"
		if [ $(which ${cmd}) ]
		then
			echo -ne "\t\tОК\n"
		else
			echo -ne "\t\tНЕ НАЙДЕН\n"
		fi
		read cmd
	done
}
function get_all_languages(){
	notfound=()
	sed -nr 's/^[^#\"]*\"([^[:blank:]]*).*/\1/p' ${PREFIX_DIR}/languages.list | uniq | check
	echo "Нажмите любую клавишу для продолжения или ctrl+c для выхода..."
	read
}
get_all_languages
find ${PREFIX_DIR} -mindepth 3 -maxdepth 3 -type f | prepare
