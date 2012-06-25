package de.hwr.damolog.model;

import de.hwr.damolog.controller.Subject;

/**
 * 
 * Repr�sentiert eine Figur
 * 
 * @author nsmeenk
 * 
 */
public class Checker extends Subject {

	private final Color _color;

	private Point _place;

	private boolean _isQueen;

	/**
	 * 
	 * @param pColor
	 * @param pStartPlace
	 */
	public Checker(Color pColor, Point pStartPlace) {
		_color = pColor;
		_place = pStartPlace;
		_isQueen = false;
	}

	/**
	 * Gibt zur�ck ob die Figur eine K�nigin ist
	 * 
	 * @return
	 */
	public boolean isQueen() {
		return _isQueen;
	}

	/**
	 * Macht aus dem Spielstein eine Dame
	 */
	public void changeToQueen() {
		_isQueen = true;
	}

	/**
	 * @return the color
	 */
	public Color getColor() {
		return _color;
	}

	/**
	 * @return the place
	 */
	public Point getPlace() {
		return _place;
	}

	/**
	 * @param pPlace
	 *            the place to set
	 */
	public void moveToPlace(Point pPlace) {
		_place = pPlace;
	}

}
