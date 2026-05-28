package com.beans;

import java.util.Objects;

public class ProductBean {

	String p_ID;
	String p_Name;
	String p_Price;
	String p_Quantity;
	String p_Image;

	
	
	//Default Constructor
	public ProductBean() {
		
	}

	public ProductBean(String p_ID, String p_Name, String p_Price, String p_Quantity, String p_Image) {
		super();
		this.p_ID = p_ID;
		this.p_Name = p_Name;
		this.p_Price = p_Price;
		this.p_Quantity = p_Quantity;
		this.p_Image = p_Image;
	}

	public String getP_ID() {
		return p_ID;
	}

	public void setP_ID(String p_ID) {
		this.p_ID = p_ID;
	}

	public String getP_Name() {
		return p_Name;
	}

	public void setP_Name(String p_Name) {
		this.p_Name = p_Name;
	}

	public String getP_Price() {
		return p_Price;
	}

	public void setP_Price(String p_Price) {
		this.p_Price = p_Price;
	}

	public String getP_Quantity() {
		return p_Quantity;
	}

	public void setP_Quantity(String p_Quantity) {
		this.p_Quantity = p_Quantity;
	}

	public String getP_Image() {
		return p_Image;
	}

	public void setP_Image(String p_Image) {
		this.p_Image = p_Image;
	}

	@Override
	public int hashCode() {
		return Objects.hash(p_ID, p_Image, p_Name, p_Price, p_Quantity);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ProductBean other = (ProductBean) obj;
		return Objects.equals(p_ID, other.p_ID) && Objects.equals(p_Image, other.p_Image)
				&& Objects.equals(p_Name, other.p_Name) && Objects.equals(p_Price, other.p_Price)
				&& Objects.equals(p_Quantity, other.p_Quantity);
	}

}
