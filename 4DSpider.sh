homesite='http://xxxx.com'	#爬取网站的根地址
website='http://xxx.com/html/yyyy/list_5_' #遍历爬取的网站地址前缀
origin_file='origin_file'
utf8_file='utf8_file'
urls_file='urls.list'  	 #用于保存 爬取的所有url链接
imgs_file='imgs.list'	 #用于保存 每个url上爬取所有图片的src
start=1	#遍历的起始网页序号
end=10	#遍历的末尾网页序号

#由于着两个文件在下面是追加写入 但是我们不想要之前的旧数据 所以把它们删除
rm $imgs_file 2> /dev/null
rm $urls_file 2> /dev/null

for((i=$start;i<=$end;i++))
do
	aimsite="$website$i".html
	curl $aimsite > $origin_file
	iconv -f cp936 -t utf8 $origin_file > $utf8_file
	grep '^<ul><li><span>2' $utf8_file | sed 's/<\/a>/\n/g' | grep 'href' | sed "s/^.*href='//g" | sed "s/'.*>/$/g" >> $urls_file
done

cat $urls_file | while read line
do
	site="$homesite$(echo $line | cut -d '$' -f1)"
	title=`echo $line | cut -d '$' -f2`
	curl $site > $origin_file
	iconv -f cp936 -t utf8 $origin_file > $utf8_file
	echo "#$title" >> $imgs_file 
	sed 's/img /\n/g' $utf8_file | grep "^src" | sed "s/src=\"//g" | sed "s/\".*//g" >> $imgs_file
done

rm $origin_file
rm $utf8_file
rm $urls_file
