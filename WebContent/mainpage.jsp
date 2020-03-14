<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="statistic.InfectStatistic"%>
<%@ page import="statistic.Lib"%>
<%@ page import="statistic.Province"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>全国疫情视图</title>
<script type="text/javascript" src="Scripts/echarts.min.js" ></script>
<script type="text/javascript" src="Scripts/china.js"></script>
<link rel="stylesheet" type="text/css" href="css/mstyles.css" />
</head>
<body>

	<%
		//path是日志文件所在的相对路径
		String path = this.getServletContext().getRealPath("/log");
		//创建一个InfectStatistic变量
		InfectStatistic is = new InfectStatistic();
		//读取日志文件
		is.getFileList(path);

		//获取日志中每一天的信息
		Lib[] datas = is.getLibs();
		//获取日志中最新一天的信息
		Lib data = datas[datas.length - 1];
		//获取日志中最新一套每一个省的信息
		Vector<Province> provinces = data.provinces;
		//获取日志最新一天的日期
		String date = data.getDate();
		//拆分日期，用于var的识别
		String[] str = date.split("-");
		String year = str[0];
		String month = str[1];
		String day = str[2];

		//用于显示昨日增加多少的信息
		String ip = "+0", cure = "+0", dead = "+0", sp = "+0", cumulativeIp = "+0";
		if (datas.length > 1) {
			Province temp = datas[datas.length - 2].provinces.get(0);
			int tempInt;
			//现有确诊增长
			tempInt = provinces.get(0).getIp() - temp.getIp();
			ip = String.valueOf(tempInt);
			if (tempInt >= 0)
				ip = "+" + String.valueOf(tempInt);
			//疑似增长
			tempInt = provinces.get(0).getSp() - temp.getSp();
			sp = String.valueOf(tempInt);
			if (tempInt >= 0)
				sp = "+" + String.valueOf(tempInt);
			//累计治愈增长
			tempInt = provinces.get(0).getCure() - temp.getCure();
			cure = String.valueOf(provinces.get(0).getCure() - temp.getCure());
			if (tempInt >= 0)
				cure = "+" + String.valueOf(tempInt);
			//累计死亡增长
			tempInt = provinces.get(0).getDead() - temp.getDead();
			dead = String.valueOf(tempInt);
			if (tempInt >= 0)
				dead = "+" + String.valueOf(tempInt);
			//累计确诊增长
			tempInt = provinces.get(0).getCumulativeIp() - temp.getCumulativeIp();
			cumulativeIp = String.valueOf(tempInt);
			if (tempInt >= 0)
				cumulativeIp = "+" + String.valueOf(tempInt);
		}
	%>

	<p id="q1">数据更新至 <%=date %></p>
	
	<div id="q2">
		<div class="a1">
			<p class="b1">现有确诊</p>
			<p class="c1"><%=data.provinces.get(0).getIp() %></p>
			<p>昨日<b class="c1"><%=ip %></b></p>
		</div>
		<div class="a1">
			<p class="b1">现有疑似</p>
			<p class="c2"><%=data.provinces.get(0).getSp() %></p>
			<p>昨日<b class="c2"><%=sp %></b></p>
		</div>
		<div class="a1">
			<p class="b1">现有重症</p>
			<p class="c3">暂无</p>
			<p>昨日<b class="c3">暂无</b></p>
		</div>
		<div class="a1">
			<p class="b1">累计确诊</p>
			<p class="c4"><%=data.provinces.get(0).getCumulativeIp() %></p>
			<p>昨日<b class="c4"><%=cumulativeIp %></b></p>
		</div>
		<div class="a1">
			<p class="b1">累计治愈</p>
			<p class="c5"><%=data.provinces.get(0).getCure() %></p>
			<p>昨日<b class="c5"><%=cure %></b></p>
		</div>
		<div class="a1">
			<p class="b1">累计死亡</p>
			<p class="c6"><%=data.provinces.get(0).getDead() %></p>
			<p>昨日<b class="c6"><%=dead %></b></p>
		</div>
	</div>
	
	<div id="q3">
		<div class="a2">
			<button id="now" type="button">现有确诊</button>
		</div>
		<div class="a2">
			<button id="all" type="button">累计确诊</button>
		</div>

	</div>
	
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main">
	</div>
	<script>
	//设定地图数据
	function setMyDatas(){
		var myData = [  
			            {name: '安徽',value: <%=provinces.get(1).getIp() %> },
			            {name: '北京',value: <%=provinces.get(2).getIp() %> },
			            {name: '重庆',value: <%=provinces.get(3).getIp() %> },
			            {name: '福建',value: <%=provinces.get(4).getIp() %> },
			            {name: '甘肃',value: <%=provinces.get(5).getIp() %> },
			            {name: '广东',value: <%=provinces.get(6).getIp() %> },
			            {name: '广西',value: <%=provinces.get(7).getIp() %> },
			            {name: '贵州',value: <%=provinces.get(8).getIp() %> },
			            {name: '海南',value: <%=provinces.get(9).getIp() %> },
			            {name: '河北',value: <%=provinces.get(10).getIp() %> },
			            {name: '河南',value: <%=provinces.get(11).getIp() %> },
			            {name: '黑龙江',value: <%=provinces.get(12).getIp() %> },
			            {name: '湖北',value: <%=provinces.get(13).getIp() %> },
			            {name: '湖南',value: <%=provinces.get(14).getIp() %> }, 
			            {name: '吉林',value: <%=provinces.get(15).getIp() %> },
			            {name: '江苏',value: <%=provinces.get(16).getIp() %> },
			            {name: '江西',value: <%=provinces.get(17).getIp() %> },
			            {name: '辽宁',value: <%=provinces.get(18).getIp() %> },
			            {name: '内蒙古',value: <%=provinces.get(19).getIp() %> },
			            {name: '宁夏',value: <%=provinces.get(20).getIp() %> },
			            {name: '青海',value: <%=provinces.get(21).getIp() %> },
			            {name: '山东',value: <%=provinces.get(22).getIp() %> },
			            {name: '山西',value: <%=provinces.get(23).getIp() %> },
			            {name: '陕西',value: <%=provinces.get(24).getIp() %> },
			            {name: '上海',value: <%=provinces.get(25).getIp() %> },
			            {name: '四川',value: <%=provinces.get(26).getIp() %> },
			            {name: '天津',value: <%=provinces.get(27).getIp() %> },
			            {name: '西藏',value: <%=provinces.get(28).getIp() %> },
			            {name: '新疆',value: <%=provinces.get(29).getIp() %> },
		                {name: '云南',value: <%=provinces.get(30).getIp() %> },  
		                {name: '浙江',value: <%=provinces.get(31).getIp() %> },
		                
		                {name: '台湾',value: <%=provinces.get(32).getIp() %> },
		                {name: '香港',value: <%=provinces.get(33).getIp() %> }, 
		                {name: '澳门',value: <%=provinces.get(34).getIp() %> }  
		            ];
		 
		var arr = document.getElementsByTagName('button');
		for (var i = 0; i < arr.length; i++)
		{
	        arr[i].onclick = function () {
	            if (this.id == 'now') 
	            {
	            	myData = [  
	            		{name: '安徽',value: <%=provinces.get(1).getIp() %> },
			            {name: '北京',value: <%=provinces.get(2).getIp() %> },
			            {name: '重庆',value: <%=provinces.get(3).getIp() %> },
			            {name: '福建',value: <%=provinces.get(4).getIp() %> },
			            {name: '甘肃',value: <%=provinces.get(5).getIp() %> },
			            {name: '广东',value: <%=provinces.get(6).getIp() %> },
			            {name: '广西',value: <%=provinces.get(7).getIp() %> },
			            {name: '贵州',value: <%=provinces.get(8).getIp() %> },
			            {name: '海南',value: <%=provinces.get(9).getIp() %> },
			            {name: '河北',value: <%=provinces.get(10).getIp() %> },
			            {name: '河南',value: <%=provinces.get(11).getIp() %> },
			            {name: '黑龙江',value: <%=provinces.get(12).getIp() %> },
			            {name: '湖北',value: <%=provinces.get(13).getIp() %> },
			            {name: '湖南',value: <%=provinces.get(14).getIp() %> }, 
			            {name: '吉林',value: <%=provinces.get(15).getIp() %> },
			            {name: '江苏',value: <%=provinces.get(16).getIp() %> },
			            {name: '江西',value: <%=provinces.get(17).getIp() %> },
			            {name: '辽宁',value: <%=provinces.get(18).getIp() %> },
			            {name: '内蒙古',value: <%=provinces.get(19).getIp() %> },
			            {name: '宁夏',value: <%=provinces.get(20).getIp() %> },
			            {name: '青海',value: <%=provinces.get(21).getIp() %> },
			            {name: '山东',value: <%=provinces.get(22).getIp() %> },
			            {name: '山西',value: <%=provinces.get(23).getIp() %> },
			            {name: '陕西',value: <%=provinces.get(24).getIp() %> },
			            {name: '上海',value: <%=provinces.get(25).getIp() %> },
			            {name: '四川',value: <%=provinces.get(26).getIp() %> },
			            {name: '天津',value: <%=provinces.get(27).getIp() %> },
			            {name: '西藏',value: <%=provinces.get(28).getIp() %> },
			            {name: '新疆',value: <%=provinces.get(29).getIp() %> },
		                {name: '云南',value: <%=provinces.get(30).getIp() %> },  
		                {name: '浙江',value: <%=provinces.get(31).getIp() %> },
		                {name: '台湾',value: <%=provinces.get(32).getIp() %> },
		                {name: '香港',value: <%=provinces.get(33).getIp() %> }, 
		                {name: '澳门',value: <%=provinces.get(34).getIp() %> }    
		            ];
	            	
	            	draw(myData);
	            } 
	            else if (this.id == 'all') 
	            {
	            	myData = [  
			            {name: '安徽',value: <%=provinces.get(1).getCumulativeIp() %> },
			            {name: '北京',value: <%=provinces.get(2).getCumulativeIp() %> },
			            {name: '重庆',value: <%=provinces.get(3).getCumulativeIp() %> },
			            {name: '福建',value: <%=provinces.get(4).getCumulativeIp() %> },
			            {name: '甘肃',value: <%=provinces.get(5).getCumulativeIp() %> },
			            {name: '广东',value: <%=provinces.get(6).getCumulativeIp() %> },
			            {name: '广西',value: <%=provinces.get(7).getCumulativeIp() %> },
			            {name: '贵州',value: <%=provinces.get(8).getCumulativeIp() %> },
			            {name: '海南',value: <%=provinces.get(9).getCumulativeIp() %> },
			            {name: '河北',value: <%=provinces.get(10).getCumulativeIp() %> },
			            {name: '河南',value: <%=provinces.get(11).getCumulativeIp() %> },
			            {name: '黑龙江',value: <%=provinces.get(12).getCumulativeIp() %> },
			            {name: '湖北',value: <%=provinces.get(13).getCumulativeIp() %> },
			            {name: '湖南',value: <%=provinces.get(14).getCumulativeIp() %> }, 
			            {name: '吉林',value: <%=provinces.get(15).getCumulativeIp() %> },
			            {name: '江苏',value: <%=provinces.get(16).getCumulativeIp() %> },
			            {name: '江西',value: <%=provinces.get(17).getCumulativeIp() %> },
			            {name: '辽宁',value: <%=provinces.get(18).getCumulativeIp() %> },
			            {name: '内蒙古',value: <%=provinces.get(19).getCumulativeIp() %> },
			            {name: '宁夏',value: <%=provinces.get(20).getCumulativeIp() %> },
			            {name: '青海',value: <%=provinces.get(21).getCumulativeIp() %> },
			            {name: '山东',value: <%=provinces.get(22).getCumulativeIp() %> },
			            {name: '山西',value: <%=provinces.get(23).getCumulativeIp() %> },
			            {name: '陕西',value: <%=provinces.get(24).getCumulativeIp() %> },
			            {name: '上海',value: <%=provinces.get(25).getCumulativeIp() %> },
			            {name: '四川',value: <%=provinces.get(26).getCumulativeIp() %> },
			            {name: '天津',value: <%=provinces.get(27).getCumulativeIp() %> },  
			            {name: '西藏',value: <%=provinces.get(28).getCumulativeIp() %> },
			            {name: '新疆',value: <%=provinces.get(29).getCumulativeIp() %> },
		                {name: '云南',value: <%=provinces.get(30).getCumulativeIp() %> },  
		                {name: '浙江',value: <%=provinces.get(31).getCumulativeIp() %> },
		                {name: '台湾',value: <%=provinces.get(32).getCumulativeIp() %> },  
		                {name: '香港',value: <%=provinces.get(33).getCumulativeIp() %> },
		                {name: '澳门',value: <%=provinces.get(34).getCumulativeIp() %> }  
		            ];
	                
	            	draw(myData);
	            }
	        };
	    }
		
		console.log(myData);
		return myData;
		 
	}
	
	myData=setMyDatas();
     
	function draw(myData){
		
		//初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
        myChart.clear();
		
		var optionMap = {  
                backgroundColor: '#D8DFD8',  
 
                tooltip : {  
                    trigger: 'item'  
                },  
                
                //左侧小导航图标
                visualMap: {  
                    show : true,  
                    x: 'left',  
                    y: 'bottom',  
                    splitList: [   
                        {start: 10000},{start: 1000, end: 9999},  
                        {start: 100, end: 999},{start: 10, end: 99},  
                        {start: 1, end: 9},{ start: 0, end: 0},  
                    ],  
                    color: ['#8D0000', '#A52A2A', '#FF6347','#FA8072','#FFFF0D',  '#FFFFFF']  
                },  
                
                //配置属性
                series: [{  
                    name: '确诊',  
                    type: 'map',  
                    mapType: 'china',   
                    roam: false,  
                    label: {  
                        normal: {  
                            show: true  //省份名称  
                        },  
                        emphasis: {  
                            show: false  
                        }  
                    },  
                    data:myData  //数据
                }]  
            };  
        
        
        //使用制定的配置项和数据显示图表
        myChart.setOption(optionMap);
		
		myChart.on('click', function (params) 
		{
			var url="DataServlet?province="
				 +params.name;
			var year=<%=year %>;
			var month=<%=month %>;
			if(month<10)
		    {
		    	month='0'+month;
		    }
			var day=<%=day %>;
			if(day<10)
		    {
		    	day='0'+day;
		    }
			url=url+"&year="+year+"&month="+month+"&day="+day;
			var newWin =window.open(url);
        });
	}
	
	draw(myData);
	 
	</script>

    <div style="width:100%;height:50px"></div>

    <table style="width:80%;margin-left:10%;text-align: center;" >
    <tr>
    <th>地区</th>
    <th>现有确诊</th>
    <th>累计确诊</th>
    <th>疑似患者</th>
    <th>治愈</th>
    <th>死亡</th>
    </tr>
    <%
    for(int i=0;i<35;i++)
    {
    %>
    <tr>
    <td><%=provinces.get(i).getName() %></td>
    <td><%=provinces.get(i).getIp() %></td>
    <td><%=provinces.get(i).getCumulativeIp() %></td>
    <td><%=provinces.get(i).getSp() %></td>
    <td><%=provinces.get(i).getCure() %></td>
    <td><%=provinces.get(i).getDead() %></td>
    </tr>
    <%} %>
    </table>
    
</body>
</html>