package com.aspects;

import com.dao.DAOInterface;

public class ObjectProviderDAO {

	public static DAOInterface createObjectDAO(String className) {

		DAOInterface obj = null;

		try {

			obj = (DAOInterface) Class.forName(className).newInstance();
			if (obj == null) {
				System.out.println("(DAO object provider) DAOInterface obj is null");
			} else {

				System.out.println("(DAO object provider) DAOInterface obj created successfully");
			}

		} catch (ClassNotFoundException e) {

			e.printStackTrace();
		} catch (InstantiationException e) {

			e.printStackTrace();
		} catch (IllegalAccessException e) {

			e.printStackTrace();
		} catch (Exception e) {

			e.printStackTrace();
		}

		return obj;
	}
}