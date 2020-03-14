package statistic;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import statistic.InfectStatistic;
import statistic.Lib;
import statistic.Province;

/**
 * Servlet implementation class DataServlet
 */
@WebServlet("/DataServlet")
public class DataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DataServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// path是日志文件的相对地址
		String path = this.getServletContext().getRealPath("/log");
		// 创建一个InfectStatistic变量
		InfectStatistic is = new InfectStatistic();
		is.getFileList(path);
		// 获取日志中的所有信息
		Lib[] datas = is.getLibs();
		// 获得jsp传来的参数
		// 省份
		String provincename = request.getParameter("province");
		// 日期
		String date = request.getParameter("year") + "-" + request.getParameter("month") + "-"
				+ request.getParameter("day");

		// 根据参数找到对应的信息
		// 对应日期
		Lib data = is.getLibByDate(date);
		// 对应省份
		Province province = data.getProvince(provincename);

		// 准备要返回的信息
		// 所有的日期，用于折线图的x轴，拆分是因为要用于var的识别
		String[] months = new String[datas.length];
		String[] days = new String[datas.length];
		// 用于折线图的数据
		// 每日的新增确诊数据
		int[] newlyIp = new int[datas.length];
		// 每日的新增累计确诊趋势
		int[] newlyCumulativeIp = new int[datas.length];
		// 每日的累计治愈/死亡
		int[] newlyCure = new int[datas.length];
		int[] newlyDead = new int[datas.length];

		// 用于网页上显示昨日+或者昨日-的信息
		int lastNewlyIp = 0, lastNewlyCure = 0, lastNewlyDead = 0, lastNewlyCumulativeIp = 0;
		if (datas.length > 1) {
			Province temp1 = datas[datas.length - 1].getProvince(provincename);
			Province temp2 = datas[datas.length - 2].getProvince(provincename);
			lastNewlyIp = temp1.getIp() - temp2.getIp();
			lastNewlyCure = temp1.getCure() - temp2.getCure();
			lastNewlyDead = temp1.getDead() - temp2.getDead();
			lastNewlyCumulativeIp = temp1.getCumulativeIp() - temp2.getCumulativeIp();
		}

		for (int i = 0; i < datas.length; i++) {
			String[] temp = datas[i].getDate().split("-");
			months[i] = temp[1];
			days[i] = temp[2];

			newlyCumulativeIp[i] = datas[i].getProvince(provincename).getCumulativeIp();
			newlyCure[i] = datas[i].getProvince(provincename).getCure();
			newlyDead[i] = datas[i].getProvince(provincename).getDead();

			if (i == 0) {
				newlyIp[i] = 0;
			} else {
				newlyIp[i] = datas[i].getProvince(provincename).getIp();
				newlyIp[i] = newlyIp[i] - datas[i - 1].getProvince(provincename).getIp();
			}

		}

		// 把这些信息装起来
		request.setAttribute("months", months);
		request.setAttribute("days", days);
		request.setAttribute("newlyIp", newlyIp);
		request.setAttribute("newlyCumulativeIp", newlyCumulativeIp);
		request.setAttribute("newlyCure", newlyCure);
		request.setAttribute("newlyDead", newlyDead);

		request.setAttribute("lastNewlyIp", lastNewlyIp);
		request.setAttribute("lastNewlyCure", lastNewlyCure);
		request.setAttribute("lastNewlyDead", lastNewlyDead);
		request.setAttribute("lastNewlyCumulativeIp", lastNewlyCumulativeIp);

		request.setAttribute("date", date);
		request.setAttribute("province", province);

		// 带着这些信息返回jsp页面
		request.getRequestDispatcher("province.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
	}

}
