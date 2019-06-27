# Note :*kalo ada $map yg tumpang tindih
# 		*kalo "done " != "done"




def print_map(size)
	for i in 0...size
		for j in 0...size
			print $map[i][j]
			print " "
		end
		print "\n"
	end
	puts "Y = You"
	puts "S = Store"
	puts "D = Driver"
end

def print_toko()
	for i in 0...3
		print i+1," ",$store_name[i],"\n"
	end
end

def print_menu(no)
	no-=1
	puts $store_name[no]
	for i in 0...$store_menu[no].size
		print i+1," ",$store_menu[no][i],"\t"
		print "= Rp",$store_price[no][i],"\n"
	end
end

$order_temp = []
def clear_order()
	$order_temp = []
	$total_dibayar = 0
	$ongkir = 0
	4.times do
		$order_temp.push(Array.new(10,0))
	end
end
def update_order(store_number,order_menu,order_qua)
	store_number-=1
	order_menu-=1
	$order_temp[store_number][order_menu]+=order_qua
end

$total_dibayar = 0
def print_checkout(store_number)
	tmp = store_number-1
	total = 0
	puts "Anda memesan :"
	for i in 0...$store_menu[tmp].size
		if $order_temp[tmp][i]>0
			price = $order_temp[tmp][i] * $store_price[tmp][i]
			total+=price
			print $store_menu[tmp][i],"\t",$order_temp[tmp][i],"\tRp",price
			print "\n"
		end
	end
	print "Total Pesanan \t:\tRp",total,"\n\n"
	$total_dibayar +=total
end

$ongkir = 0
def calculate_ongkir(store_number)
	no = store_number-1
	jarak = ($store_x[no]-$position_x).abs + ($store_y[no]-$position_y).abs
	$ongkir = 1000 * jarak
	$total_dibayar+=$ongkir
	print "Biaya Antar \t:\tRp",$ongkir,"\n"
end

$rating_ojek = Array.new(10,0.0)
$divide_rating = Array.new(10,0)
def update_rating(ojek_number)
	puts "Silahkan beri penilaian (rating) dengan skala 1 - 5"
	rate = gets.chomp.to_i
	if rate > 5
		rate = 5
	end
	if rate < 1
		rate = 1
	end
	no = ojek_number-1
	$divide_rating[no] += 1
	$rating_ojek[no] += (rate*1.0)
	rating = $rating_ojek[no] / $divide_rating[no]
	if rating < 3
		puts "Sistem mencari driver"
		$rating_ojek[no] = 0.0
		$divide_rating[no] = 0
		$count_ojek += 1
		$number_ojek[no] = $count_ojek
		print "Driver ",$number_ojek[no]," telah terdaftar\n"
		$map[$ojek_x[no]][$ojek_y[no]] = "D" + $number_ojek[no].to_s
	end


end

def print_rating(ojek_number)
	no = ojek_number-1
	ret = $rating_ojek[no] / $divide_rating[no]
	print ret.round(1),"\n"
end

def skema_antar(ojek,n)
	
	print "Driver ",$number_ojek[ojek-1]," akan mengambil pesanan anda\n\n"
	$cek[$ojek_x[ojek-1]][$ojek_y[ojek-1]] = false
	$map[$ojek_x[ojek-1]][$ojek_y[ojek-1]] = "* "
	tmp_x = Random.rand(n)
	tmp_y = Random.rand(n)
	while $cek[tmp_x][tmp_y]
		tmp_x = Random.rand(n)
		tmp_y = Random.rand(n)
	end
	$cek[tmp_x][tmp_y] = true
	$ojek_y[ojek-1] = tmp_y
	$ojek_x[ojek-1] = tmp_x
	$map[$ojek_x[ojek-1]][$ojek_y[ojek-1]] = "D" + $number_ojek[ojek-1].to_s
end

$history_store = []
$history_menu = []
$history_ongkir = []
$history_ojek = []
def update_history(store_number,order_menu,order_qua,ojek)
	tmp = store_number-1
	$history_store.push(tmp)
	$history_ongkir.push($ongkir)
	$history_menu.push(Array.new(3,0))
	$history_ojek.push($number_ojek[ojek-1])
	tmp1 = $history_store.size()-1
	for i in 0..2
		$history_menu[tmp1][i] = $order_temp[tmp][i]
	end
end

def print_history()
	puts "HISTORY "
	if($history_store.size() == 0)
		puts "Tidak ada History, anda belum memesan"
	else 
		for i in ($history_store.size()-1).downto 0
			print $store_name[$history_store[i]],"\n"
			tmp = $history_store[i]
			total = 0
			for j in 0..2
				if $history_menu[i][j] > 0
					print "\t",$store_menu[$history_store[i]][j]
					print "\t",$history_menu[i][j]
					price = $store_price[$history_store[i]][j]*$history_menu[i][j]
					total += price
					print "\t",price,"\n"
				end
			end
			total += $history_ongkir[i]
			print "\tBiaya Antar \t:\t",$history_ongkir[i],"\n"
			print "\tTotal \t\t:\tRp",total,"\n"
			print "\tDriver oleh Driver ",$history_ojek[i],"\n"
		end
	end
end

	

# puts "Input $map_size"
# n = gets.chomp.to_i
# puts "Input $position_x"
# x = gets.chomp.to_i
# puts "Input $position_y"
# y = gets.chomp.to_i

n = 20
$position_x = Random.rand(n) 
$position_y = Random.rand(n)

$store_name = ["Bakso Pak Ndut ", "Bakmie Pak Min ", "Sop Kambing Hj. Soma "]
$store_menu = []
$store_price = []
4.times do
	$store_menu.push(Array.new(10))
	$store_price.push(Array.new(10))
end

$store_menu[0] = ["Bakso Biasa", "Bakso Spesial", "Bakso Jumbo"]
$store_menu[1] = ["Bakmie Ayam", "Bakmie Yamin", "Bakmie Top"]
$store_menu[2] = ["Sop Kambing", "Sop Buntut", "Sop Betawi"]
$store_price[0] = [12000, 15000, 18000]
$store_price[1] = [13000, 16000, 20000]
$store_price[2] = [20000, 20000, 25000]

$map = []
$cek = []
n.times do
	$map.push(Array.new(n,"* "))
	$cek.push(Array.new(n,false))
end

$ojek_x = []
$ojek_y = []
$map[$position_x][$position_y] = "Y "
$cek[$position_x][$position_y] = true
$number_ojek = [1,2,3,4,5]
$count_ojek = 5

for i in 0...5
	tmp_x = Random.rand(n)
	tmp_y = Random.rand(n)
	while $cek[tmp_x][tmp_y]
		tmp_x = Random.rand(n)
		tmp_y = Random.rand(n)
	end
	$cek[tmp_x][tmp_y] = true
	$ojek_y[i] = tmp_y
	$ojek_x[i] = tmp_x
end

for i in 0..4
	$map[$ojek_x[i]][$ojek_y[i]] = "D" + $number_ojek[i].to_s
end

# kalo ada ojek yang lokasinya samaan

$store_x = []
$store_y = []

for i in 0...5
	tmp_x = Random.rand(n)
	tmp_y = Random.rand(n)
	while $cek[tmp_x][tmp_y]
		tmp_x = Random.rand(n)
		tmp_y = Random.rand(n)
		# print tmp_x, " ", tmp_y
		# print "\n"
	end
	$cek[tmp_x][tmp_y] = true
	$store_y[i] = tmp_y
	$store_x[i] = tmp_x
end

for i in 0..2
	$map[$store_x[i]][$store_y[i]] = "S"+(i+1).to_s
end

print_map(n)
print "\n"
while(true)
	puts "Input : ('map') untuk lihat map, ('history') untuk lihat history, ('pesan') untuk pesan, ('exit') untuk keluar"
	input_pesan = gets.chomp.downcase
	clear_order()
	break if(input_pesan.index("exit") != nil)
	if(input_pesan.index("map") != nil)
		print_map(n)
		print "\n"
	elsif(input_pesan.index("history") != nil)
		print_history()
		print "\n"
	elsif(input_pesan.index("pesan") != nil)
		store_number = 0
		pesan = false
		while(!pesan)
			puts "Silahkan pilih Toko"
			print_toko()
			puts "Masukkan no toko (1, 2, atau 3)"
			store_number = gets.chomp.to_i
			print "\n"
			print_menu(store_number)
			puts "Pesan atau Kembali? (input : pesan / kembali)"
			input_pesan = gets.chomp.downcase
			if(input_pesan.index("pesan") != nil)
				pesan = true
			end
			print "\n"
		end

		puts "Silahkan input dengan format : No. menu (spasi) jumlah order"
		puts "Jika sudah, input: 'done' "

		order_menu = 0
		order_qua = 0
		clear_order
		while(true)
			order_menu, order_qua= gets.split.map(&:to_s)
			break if(order_menu.downcase.index("done") != nil)
			order_menu = order_menu.to_i
			order_qua = order_qua.to_i
			if order_menu > 9
				order_menu = 9
			end
			update_order(store_number,order_menu,order_qua)
			if(order_menu <= $store_menu[store_number-1].size)
				print $store_menu[store_number-1][order_menu-1],"\t",$order_temp[store_number-1][order_menu-1],"\n"
			end
		end

		print_checkout(store_number)
		calculate_ongkir(store_number)

		print "Total \t\t:\tRp",$total_dibayar,"\n"

		ojek = Random.rand(1..5)
		skema_antar(ojek,n)
		update_history(store_number,order_menu,order_qua,ojek)
		update_rating(ojek)
		
	end
end



