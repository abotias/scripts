for ( $i = 1; $i -lt $args.count; $i++ ) {
	$template=$args[0]
	$name=$args[$i]
    & 'C:\Program Files\VMware\VMware OVF Tool\ovftool.exe' --name="$name" -dm=thin --datastore="<datastore>" C:\Users\<user>\Desktop\A\$template\$template.ovf vi://@<ip>/
}
