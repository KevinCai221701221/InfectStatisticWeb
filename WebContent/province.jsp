<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<%@ page import="statistic.InfectStatistic"%>
<%@ page import="statistic.Lib"%>
<%@ page import="statistic.Province"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.String" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>省份疫情视图</title>
<script type="text/javascript" src="Scripts/echarts.min.js" ></script>
<link rel="stylesheet" type="text/css" href="css/pstyles.css" />
</head>
<body>

	<%
		Province province = (Province) request.getAttribute("province");
		String date = (String) request.getAttribute("date");

		int temp = (int) request.getAttribute("lastNewlyIp");
		String lastNewlyIp = String.valueOf(temp);
		if (temp >= 0)
			lastNewlyIp = "+" + lastNewlyIp;

		temp = (int) request.getAttribute("lastNewlyCure");
		String lastNewlyCure = String.valueOf(temp);
		if (temp >= 0)
			lastNewlyCure = "+" + lastNewlyCure;

		temp = (int) request.getAttribute("lastNewlyDead");
		String lastNewlyDead = String.valueOf(temp);
		if (temp >= 0)
			lastNewlyDead = "+" + lastNewlyDead;

		temp = (int) request.getAttribute("lastNewlyCumulativeIp");
		String lastNewlyCumulativeIp = String.valueOf(temp);
		if (temp >= 0)
			lastNewlyCumulativeIp = "+" + lastNewlyCumulativeIp;
	%>

	<h1 id="q1" ><%=province.getName() %></h1>
	
	<p id="q2">更新至<%=date %></p>
	
     <div id="q3">
	    <div class="a1">
			<p class="b1">现有确诊</p>
			<p class="c1"><%=province.getIp() %></p>
			<p>昨日<b class="c1"><%=lastNewlyIp %></b></p>
		</div>
		<div class="a1">
			<p class="b1">累计确诊</p>
			<p class="c2"><%=province.getCumulativeIp() %></p>
			<p>昨日<b class="c2"><%=lastNewlyCumulativeIp %></b></p>
		</div>
		<div class="a1">
			<p class="b1">累计治愈</p>
			<p class="c3"><%=province.getCure() %></p>
			<p>昨日<b class="c3"><%=lastNewlyCure %></b></p>
		</div>
		<div class="a1">
			<p class="b1">累计死亡</p>
			<p class="c4"><%=province.getDead() %></p>
			<p>昨日<b class="c4"><%=lastNewlyDead %></b></p>
		</div>
    </div>
	
	<div id="main">
		此处有折线图
	</div>
	
	<div id="q4">
		<div class="a2">
		    <button id="now" class="button1" type="button">新增确诊趋势</button>
		</div>
		<div class="a2">
		    <button id="all" class="button1" type="button">累计确诊趋势</button>
		</div>
		<div class="a2">
			<button id="DeadAndCure" class="button1" type="button">累计治愈/死亡趋势</button>
		</div>
	</div>
	
	<script>
	
		var i = 0;
		var xDate = new Array();

		var newlyIp = new Array();
		var newlyCumulativeIp = new Array();
		var newlyCure = new Array();
		var newlyDead = new Array();
		
	<%String[] months = (String[]) request.getAttribute("months");
			String[] days = (String[]) request.getAttribute("days");

			int[] newlyIp = (int[]) request.getAttribute("newlyIp");
			int[] newlyCumulativeIp = (int[]) request.getAttribute("newlyCumulativeIp");
			int[] newlyCure = (int[]) request.getAttribute("newlyCure");
			int[] newlyDead = (int[]) request.getAttribute("newlyDead");

			for (int i = 0; i < months.length; i++) {%>
	var month=<%=months[i] %>;
	if(month<10)month='0'+month;
	var day=<%=days[i] %>;
	if(day<10)day='0'+day;
	xDate[i]=month+"-"+day;
	
	newlyIp[i]=<%=newlyIp[i] %>;
	newlyCumulativeIp[i]=<%=newlyCumulativeIp[i] %>;
	newlyCure[i]=<%=newlyCure[i] %>;
	newlyDead[i]=<%=newlyDead[i] %>;
	
	i=i+1;
	<%} %>
	
	function setData()
	{
		var option = {
                title:{
                    text:'新增确诊趋势',//标题
                    left: 'left',//标题位置
                },
                //提示框组件
                tooltip:{
                    //坐标轴触发，主要用于柱状图，折线图等
                    trigger:'axis'
                },
                //横轴
                xAxis:{
                    data:xDate
                },
                //纵轴
                yAxis:{
                	name:'单位：例'
                },
                //系列列表。每个系列通过type决定自己的图表类型
                series:[{
	    	                 name:'新增确诊',//series名称
	    	                 type:'line',//series图表类型,line折线图 、scatter散点图
	    	                 data: newlyIp  //  
	    	                }]
            };
		
		var arr = document.getElementsByTagName('button');
		for (var i = 0; i < arr.length; i++)
		{
	        arr[i].onclick = function () {
	            if (this.id == 'now') 
	            {
	            	option = {
	                        title:{
	                            text:'折线图实例',//标题
	                            left: 'center',//标题位置
	                        },
	                        //提示框组件
	                        tooltip:{
	                            //坐标轴触发，主要用于柱状图，折线图等
	                            trigger:'axis'
	                        },
	                        //横轴
	                        xAxis:{
	                            data:xDate
	                        },
	                        //纵轴
	                        yAxis:{
                	            name:'单位：例'
                            },
	                        //系列列表。每个系列通过type决定自己的图表类型
	                        series:[{
	                        	name:'新增确诊',//series名称
	        	    	        type:'line',//series图表类型,line折线图 、scatter散点图
	        	    	        data: newlyIp  //  
	        	    	                }]
	                    };
	            	
	            	draw(option);
	            }
	            else if(this.id=='all')
	            {
	            	option = {
	                        title:{
	                            text:'累计确诊趋势',//标题
	                            left: 'left',//标题位置
	                        },
	                        //提示框组件
	                        tooltip:{
	                            //坐标轴触发，主要用于柱状图，折线图等
	                            trigger:'axis'
	                        },
	                        //横轴
	                        xAxis:{
	                            data:xDate
	                        },
	                        //纵轴
	                        yAxis:{
                	            name:'单位：例'
                            },
	                        //系列列表。每个系列通过type决定自己的图表类型
	                        series:[{
	                        	name:'累计确诊',//series名称
	        	    	        type:'line',//series图表类型,line折线图 、scatter散点图
	        	    	        data: newlyCumulativeIp  //  
	        	    	                }]
	                    };
	            	
	            	draw(option);
	            }
	            else if(this.id=='DeadAndCure')
	            {
	            	option = {
	                        title:{
	                            text:'累计治愈/死亡趋势',//标题
	                            left: 'left',//标题位置
	                        },
	                        //提示框组件
	                        tooltip:{
	                            //坐标轴触发，主要用于柱状图，折线图等
	                            trigger:'axis'
	                        },
	                        //横轴
	                        xAxis:{
	                            data:xDate
	                        },
	                        //纵轴
	                        yAxis:{
                	            name:'单位：例'
                            },
	                        //系列列表。每个系列通过type决定自己的图表类型
	                        series:[{
	                        	name:'治愈',//series名称
	        	    	        type:'line',//series图表类型,line折线图 、scatter散点图
	        	    	        data:newlyCure  //
	        	    	        },{
	        	    	        	name:'死亡',//series名称
	        	    	            type:'line',//series图表类型,line折线图 、scatter散点图
	        	    	            data:newlyDead //
	        	    	                }]
	                    };
	            	
	            	draw(option);
	            	}
	        }
		}
		
		console.log(option);
		return option;
	}
	
	var option=setData();
	
	function draw(option)
	{
		//基于准备好的DOM，初始化echarts实例--echarts.init() 方法初始化一个 ECharts 实例，在 init() 中传入图表容器 Dom 对象，
        var myChart = echarts.init(document.getElementById('main'));
          //指定图表的配置项和数据
        myChart.clear();
            //使用刚指定的配置项和数据显示图表
        myChart.setOption(option);
	}
    
	draw(option);
	
    </script>
	

</body>
</html>