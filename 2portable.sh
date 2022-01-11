rm -rf tmp/* *portable.json;
for collection in `ls *.json`;
do
  folder=`echo $collection | cut -d'.' -f1`
  rm -rf $folder;
  mkdir $folder;
  cat $collection | grep "D:" | cut -d'"' -f4 | sed 's/file:\/\/\///' > "tmp/${folder}files.txt";
  cat $collection | grep "C:" | cut -d'"' -f4 | sed 's/file:\/\/\///' >> "tmp/${folder}files.txt";
  cp $collection "${folder}_portable";
  while IFS= read -r line
  do
    echo "$folder > $line";
    cp "$line" $folder/;
    filename=`echo $line | awk -F/ '{print $NF}'`;
    awk "{sub(\"$line\",\"ROOTPATH/$filename\")}1" "${folder}_portable" > tmp.txt;
    mv tmp.txt "${folder}_portable";
  done < "tmp/${folder}files.txt";
done

for collection in `ls *_portable`;
do
  mv $collection "${collection}.json";
done