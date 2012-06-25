package de.hwr.damolog.model;

/**
 * 
 * Speichert Koordinaten
 * 
 * @author nsmeenk
 * 
 */
public class Point {

	private int _x;

	private int _y;

	/**
	 * Konstruktor für die Position auf einem Feld
	 * 
	 * @param pX
	 *            X
	 * @param pY
	 *            Y
	 */
	public Point(int pX, int pY) {
		_x = pX;
		_y = pY;
	}

	/**
	 * @return the x
	 */
	public int getX() {
		return _x;
	}

	/**
	 * @param pX
	 *            the x to set
	 */
	public void setX(int pX) {
		_x = pX;
	}

	/**
	 * @return the y
	 */
	public int getY() {
		return _y;
	}

	/**
	 * @param pY
	 *            the y to set
	 */
	public void setY(int pY) {
		_y = pY;
	}

}
