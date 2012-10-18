imgs_file='imgs.list' #存储着图片src的文件
imgs_dir='./img' 	#用于保存下载图片的路经 
exist_file='exist.list' #用于保存之前已经下载过的标题

mkdir $imgs_dir

cat $imgs_file | while read line
do
	if [[ "$line" =~ "#" ]];then
	{
		line=`echo $line | sed 's/\ //g' | sed 's/\[/(/g' | sed 's/\]/)/g'`
		flag=`grep "$line" $exist_file`
		if [[ "$flag" == "" ]];then
			lock="false"
			echo $line >> $exist_file
			echo "不存在 $line"
			wait
		else
			lock="true"
			echo "存在 $line"
		fi
	}
	else
		if [[ "$lock" == "false" ]];then
		{
			wget $line -P "$imgs_dir" -t 1
		}&
		fi
	fi
done
