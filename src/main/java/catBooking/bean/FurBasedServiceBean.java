package catBooking.bean;

import java.io.Serializable;

public class FurBasedServiceBean extends ServiceBean implements Serializable{

	private static final long serialVersionUID = 1L;
	private String furType;

	public FurBasedServiceBean() {}

	//getter and setter
	public String getFurType() {
		return furType;
	}

	public void setFurType(String furType) {
		this.furType = furType;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}