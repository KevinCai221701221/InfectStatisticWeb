package statistic;

import java.io.*;
import java.lang.String;


public class InfectStatistic {

	Lib libs[];// 用于存储某天的日志的数组
	int count = 0;// 用于纪律当前已经存了多少天的日志的计数单�?
	int isIn[] = new int[35];// 用于记录用户要求查询哪个省的数组

	// 读文件的函数
	public void getFileList(String log) {
		File file = new File(log);
		File[] fileList = file.listFiles();
		// 根据txt文件的数量创建对应容量的数组
		libs = new Lib[fileList.length];
		// �?始读文件
		for (int i = 0; i < fileList.length; i++) {
			if (fileList[i].isFile()) {
				// 是文件就按行读取
				String fileName = fileList[i].getName();
				// 根据文件名创建对应的lib元素，截取日期当作元素的date
				String substr = fileList[i].getName().substring(0, 10);
				libs[count] = new Lib(substr);
				count = count + 1;
				addYesterday();
				// 读文�?
				readFileByLines(log + "\\" + fileName, libs[count - 1]);
			}
			if (fileList[i].isDirectory()) {
				// 是目录就递归读取
				String fileName = fileList[i].getName();
				getFileList(log + "\\" + fileName);
			}
		}
	}

	// 按行读取文件
	public void readFileByLines(String fileName, Lib lib) {

		BufferedReader reader = null;
		try {
			InputStreamReader read = new InputStreamReader(new FileInputStream(fileName), "GBK");
			reader = new BufferedReader(read);
			String line = null;
			while ((line = reader.readLine()) != null) {
				opData(line, lib);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	// 处理数据的函�?
	public void opData(String data, Lib lib) {
		String[] strarray = data.split(" |人");
		if (strarray.length == 5) {
			// 人员流动的情�?
			turnover(lib, strarray);
		} else if (strarray.length == 4) {
			// 确诊或�?�增长或者排除的情况
			confirmOrIncreaseOrExclude(lib, strarray);
		} else if (strarray.length == 3) {
			// 治愈或�?�死亡的情况
			cureOrDie(lib, strarray);
		}
	}

	// 在全国的省份中找到对应省份的函数,lib是日期，y是省
	public int findProvinceInDate(Lib lib, String[] strarray, int y) {
		for (int i = 0; i < lib.provinces.size(); i++) {
			Province temp = lib.provinces.get(i);
			if (temp.getName().contentEquals(strarray[y]) == true) {
				// 如果找到就返回下�?,并标识出它是当天改变的省�?
				temp.setIsChange();
				return i;
			}
		}
		// 找不到返�?-1
		return -1;
	}

	// 处理人口流动情况的函�?
	public void turnover(Lib lib, String[] strarray) {
		Province temp1, temp2;
		int i = findProvinceInDate(lib, strarray, 0), j = findProvinceInDate(lib, strarray, 3);
		if (i != -1 && j != -1) {
			// temp1是省1
			temp1 = lib.provinces.get(i);
			// temp2是省2
			temp2 = lib.provinces.get(j);
			if (strarray[1].contentEquals("感染患者") == true) {
				temp1.moveIp(Integer.parseInt(strarray[4]));
				temp2.addIp(Integer.parseInt(strarray[4]));
			} else {
				temp1.moveSp(Integer.parseInt(strarray[4]));
				temp2.addSp(Integer.parseInt(strarray[4]));
			}
			lib.provinces.remove(i);
			lib.provinces.insertElementAt(temp1, i);
			lib.provinces.remove(j);
			lib.provinces.insertElementAt(temp2, j);
		} else {
			System.out.println("流入发生错误");
		}
	}

	// 处理死亡或�?�治愈情况的函数
	public void cureOrDie(Lib lib, String[] strarray) {
		int i = findProvinceInDate(lib, strarray, 0);
		if (i != -1) {
			Province temp1 = lib.provinces.get(i);
			Province temp2 = lib.provinces.get(0);
			if (strarray[1].contentEquals("死亡") == true) {
				temp1.moveIp(Integer.parseInt(strarray[2]));
				temp1.addDead(Integer.parseInt(strarray[2]));
				temp2.moveIp(Integer.parseInt(strarray[2]));
				temp2.addDead(Integer.parseInt(strarray[2]));
			} else {
				temp1.moveIp(Integer.parseInt(strarray[2]));
				temp1.addCure(Integer.parseInt(strarray[2]));
				temp2.moveIp(Integer.parseInt(strarray[2]));
				temp2.addCure(Integer.parseInt(strarray[2]));
			}
			lib.provinces.remove(i);
			lib.provinces.insertElementAt(temp1, i);
			lib.provinces.remove(0);
			lib.provinces.insertElementAt(temp2, 0);

		} else {
			System.out.println("治愈死亡发生错误");
		}
	}

	// 处理确诊排除或�?�增长情况的函数
	public void confirmOrIncreaseOrExclude(Lib lib, String[] strarray) {
		int i = findProvinceInDate(lib, strarray, 0);
		if (i != -1) {
			Province temp1 = lib.provinces.get(i);
			Province temp2 = lib.provinces.get(0);
			if (strarray[1].contentEquals("新增") == true) {
				if (strarray[2].contentEquals("感染患者") == true) {
					temp1.addIp(Integer.parseInt(strarray[3]));
					temp2.addIp(Integer.parseInt(strarray[3]));
				} else {
					temp1.addSp(Integer.parseInt(strarray[3]));
					temp2.addSp(Integer.parseInt(strarray[3]));
				}
			} else if (strarray[1].contentEquals("排除") == true) {
				temp1.moveSp(Integer.parseInt(strarray[3]));
				temp2.moveSp(Integer.parseInt(strarray[3]));
			} else {
				temp1.moveSp(Integer.parseInt(strarray[3]));
				temp1.addIp(Integer.parseInt(strarray[3]));
				temp2.moveSp(Integer.parseInt(strarray[3]));
				temp2.addIp(Integer.parseInt(strarray[3]));
			}
			lib.provinces.remove(i);
			lib.provinces.insertElementAt(temp1, i);
			lib.provinces.remove(0);
			lib.provinces.insertElementAt(temp2, 0);

		} else {
			System.out.println("确诊排除增加发生错误");
		}
	}

	// 把昨天的数据加到今天的函�?
	public void addYesterday() {
		Province temp1, temp2;
		if (count > 1) {
			for (int i = 0; i < libs[count - 2].provinces.size(); i++) {
				temp1 = libs[count - 1].provinces.get(i);
				temp2 = libs[count - 2].provinces.get(i);
				temp1.addIp(temp2.getIp());
				temp1.addSp(temp2.getSp());
				temp1.addCure(temp2.getCure());
				temp1.addDead(temp2.getDead());
			}
		}
	}

	// 从输入的province参数找到对应的省�?
	public void whatIn(int x, String province) {
		String[] strarray = province.split(" ");
		int i = 0, find = 0;
		do {
			if (libs[x].provinces.get(i).getName().contentEquals(strarray[find]) == true) {
				isIn[i] = 1;
				find = find + 1;
			}
			i = i + 1;
			if (i == libs[x].provinces.size()) {
				i = 0;
			}
		} while (find < strarray.length);

	}

	// 根据输入的date参数找到对应的日�?
	public int findDate(String date) {
		if (date.contentEquals(" ") == true)
			return libs.length - 1;
		else if (date.compareTo(libs[libs.length - 1].getDate()) > 0) {
			return -1;
		} else if (date.compareTo(libs[0].getDate()) < 0) {
			return -1;
		} else {
			for (int i = 0; i < libs.length; i++) {
				if (date.contentEquals(libs[i].getDate()) == true)
					return i;
				else if (i + 1 < libs.length) {
					if (date.compareTo(libs[i].getDate()) > 0 && date.compareTo(libs[i + 1].getDate()) < 0) {
						return i;
					}
				}
			}
		}
		return -1;
	}

	public Lib[] getLibs() {
		return this.libs;
	}

	public Lib getLibByDate(String date) {
		for (int i = 0; i < libs.length; i++) {
			if (date.contentEquals(libs[i].getDate()) == true)
				return libs[i];
		}
		return null;
	}

	public void outList(String type, String date, String province) {
		int x = findDate(date);
		if (province.contentEquals(" ") == true) {
			libs[x].provinces.get(0).setIsChange();
			for (int k = 0; k < libs[x].provinces.size(); k++) {
				Province temp = libs[x].provinces.get(k);
				System.out.print(temp.ToString());
			}
		}

	}

}