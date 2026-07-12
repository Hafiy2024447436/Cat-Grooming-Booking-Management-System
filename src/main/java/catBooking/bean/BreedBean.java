package catBooking.bean;

import java.io.Serializable;

public class BreedBean implements Serializable{

	private static final long serialVersionUID = 1L;
	private int breedID; 
	private String breedName;

	public BreedBean() {}

	//getter and setter
	public int getBreedID() {
		return breedID;
	}

	public void setBreedID(int breedID) {
		this.breedID = breedID;
	}

	public String getBreedName() {
		return breedName;
	}

	public void setBreedName(String breedName) {
		this.breedName = breedName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}