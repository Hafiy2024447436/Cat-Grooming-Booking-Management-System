package catBooking.bean;

import java.io.Serializable;

public class WeightBasedServiceBean extends ServiceBean implements Serializable{

	private static final long serialVersionUID = 1L;
	private String weightRange;

	public WeightBasedServiceBean() {}

	//getter and setter
	public String getWeightRange() {
		return weightRange;
	}

	public void setWeightRange(String weightRange) {
		this.weightRange = weightRange;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}