
import matplotlib.pyplot as plt

#number_pack = input("Введите разницу пакетов")
#mod_count_1 = int(0)
#mod_count_2 = int(0)
#rest_number = int(5)
#temp_value_1 = int(5)
#temp_value_2 = int(number_pack)
#temp_while = 1
i_n1 = int(2)
i_n2 = int(4)
#первый выбор

while(1):
    pack_min = input("Введите минимальный размер пакета. Возможный минимальный 64")
    if(64>int(pack_min))|(int(pack_min)>1517):
        print("вы неправильно ввели число не из диапазона. min")
    else:
        break
while(1):
    pack_max = input("Введите максимальный размер пакета. Возможный максимальный 1518")
    if(int(pack_min)>=int(pack_max))|(int(pack_max)>1518):
        print("вы неправильно ввели число не из диапазона. max")
    else:
        break
number_pack = int(pack_max) - int(pack_min) + 1
print("Разница пакетов = ", number_pack)
var_y = input("Если хотите тестировать распределение нажмите y")
while(1):

    #while(1):
    #    number_pack = input("Введите разницу пакетов + 1. Мин 2, Макс 1454")
    #    if(2>int(number_pack))|(int(number_pack)>1454):
    #        print("вы неправильно ввели число не из диапазона")
    #    else:
    #        break

    mod_count_1 = int(0)
    mod_count_2 = int(0)
    rest_number = int(5)
    temp_value_1 = int(5)
    temp_value_2 = int(number_pack)
    temp_while = 1
    while temp_value_2 != 0:

        while temp_while :
            if i_n2 > (int(temp_value_2)) >= i_n1:
                temp_value_1 = i_n1
                temp_while = 0
                i_n1 = 2
                i_n2 = 4
                break
            elif i_n2 > 2000:
                temp_while = 0
                print("ошибка")
            i_n1 = i_n1 * 2
            i_n2 = i_n2 * 2
            print(i_n1, i_n2)

        if ((mod_count_1 == 0) & (mod_count_2 == 0)):
            mod_count_1 = temp_value_1
            temp_value_2 = temp_value_2 - mod_count_1
            if (temp_value_2 >= 2):
                temp_while = 1
                print(temp_value_2)
            else:
                rest_number = temp_value_2 - mod_count_2
                temp_value_2 = 0
            print("Назначился первый мод")
        elif (mod_count_2 == 0):
            mod_count_2 = temp_value_1
            rest_number = temp_value_2 - mod_count_2
            temp_value_2 = 0
            print("Назначился второй мод")
    print( mod_count_1, mod_count_2, rest_number)
    if var_y != "y":
        break

i = 0
i_mod1 = 0
i_mod2 = 0
i_rest = 0
x = 5
x_m1 = 5
x_m2 = 5
x_rt = 0
c = 1
a = 5
grap_x = [0]
grap_x_test = [0]

#для обнуления счетчиков
flag_mod1 = 0
flag_mod2 = 0
flag_rest = 0
flag_start =0

test_value_rand = input("если хотите проверить ранд мода_1 то жми: y")
new_number = input("если не хотите переназначить колличестов пакетов, то введите больше 1, нет то 1")
number_control = number_pack
if int(new_number) >= 2:
    number_pack = new_number

if test_value_rand == "y":
    while i < int(number_pack):
        i += 1
        x=(a*x+c)%mod_count_1
        if i ==1:
            grap_x[0] = x
        else:
            grap_x.append(x)
        #print("i=",i)
    print(grap_x, number_pack)
else:
    while i < int(number_pack):
        print("старт i=", i)

        if i_mod1 < mod_count_1:
            i_mod1 += 1
            x_m1 = (a * x_m1 + c) % mod_count_1
            if (i_mod1 == 1) & (int (flag_start)==0):
                grap_x[0] = x_m1 + int(pack_min)
                print(grap_x[0])
                flag_start = 1
            else:
                grap_x.append(x_m1 + int(pack_min))
            print("mod1",x_m1)
            i += 1
        else:
            flag_mod1 = 1
        if (i_mod2 < mod_count_2)&(mod_count_2 != 0)&(i < int(number_pack)):
            i_mod2 += 1
            x_m2 = (a * x_m2 + c) % mod_count_2
            grap_x.append((x_m2)+(mod_count_1) + int(pack_min))
            print("mod2",x_m2)
            i += 1
        else:
            flag_mod2 = 1
        if (i_rest < rest_number)&(rest_number != 0)&(i < int(number_pack)):
            x_rt = i_rest + (mod_count_1) + (mod_count_2)
            i_rest += 1
            grap_x.append(x_rt + int(pack_min))
            print("rest",x_rt)
            i += 1
        else:
            flag_rest = 1
        print("конец цикла i=", i)

        if ((flag_mod2 & flag_mod1 & flag_rest) == 1):
            print("обновление", i, number_pack)
            i_mod1 = 0
            i_mod2 = 0
            i_rest = 0
            x_rt = 0
            x_m1 = x_m1 + 1
            x_m2 = x_m2 + 1
            flag_mod1 = 0
            flag_mod2 = 0
            flag_rest = 0



    print(grap_x)
    print(mod_count_1,mod_count_2,rest_number)
    i = 0
    while i < int(number_control):
        print("Колличество пакетов ", (i+ int(pack_min)), "= ", grap_x.count(i + int(pack_min)), ":",grap_x.count(i + int(pack_min))/ int(number_pack)*100, "%" )
        i += 1

#график
a_graf = [1,2,3,4,5]
b_graf = [1,2,3,4,5]
#plt.plot(a_graf,b_graf)
plt.plot(grap_x)
plt.show()

#65-71, 65-70, 65-68
# 65-71 = 7, 14=14, 15 = 14, 16 =17, 18 =17, 17= 17