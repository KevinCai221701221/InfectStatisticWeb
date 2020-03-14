package statistic;

public class Province {
	private String name;//省份的名�?
	private int ip;//感染患�??
	private int cumulativeIp;//累计确诊
	private int severeIp;//重症患者
	private int sp;//疑似患�??
	private int cure;//治愈
	private int dead;//死亡
	private int isChange;//当天是否被改�?
	
	public Province(String name)//构�?�函�?
	{
		this.name=name;
		ip=0;
		cumulativeIp=0;
		severeIp=0;
		sp=0;
		cure=0;
		dead=0;
		isChange=0;
	}

	public int getIsChange()
	{
		return isChange;
	}
	public void setIsChange()
	{
		isChange=1;
	}
	
	public String getName()
	{
		return name;
	}
	
	public int getIp()
	{
		return ip;
	}
	
	public int getSp()
	{
		return sp;
	}
	
	public int getCure()
	{
		return cure;
	}
	
	public int getDead()
	{
		return dead;
	}
	
	public int getCumulativeIp()
	{
		return cumulativeIp=ip+cure+dead;
	}
	
	public int getSevereIp()
	{
		return severeIp;
	}
	
	public void addIp(int x)//增加感染�?
	{
		ip=ip+x;
	}
	
	public void addSp(int x)//增加疑似患�??
	{
		sp=sp+x;
	}
	
	public void addCure(int x)
	{
		cure=cure+x;
	}
	
	public void addDead(int x)
	{
		dead=dead+x;
	}
	
	public void moveIp(int x)
	{
		ip=ip-x;
		if(ip<0)
			ip=0;
	}
	
	public void moveSp(int x)
	{
		sp=sp-x;
		if(sp<0)
			sp=0;
	}
	
	public String ToString()
	{
		return name+" 感染患者"+ip+"人 疑似患者"+sp
				+"人 治愈"+cure+"人 死亡"+dead+"人\n";
	}
	
	public String outIp()
	{
		return "感染患者"+ip+"人";
	}
	
	public String outSp()
	{
		return "疑似患者"+sp+"人";
	}
	
	public String outCure()
	{
		return "治愈"+cure+"人";
	}
	
	public String outDead()
	{
		return "死亡"+dead+"人";
	}
}
