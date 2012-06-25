package de.hwr.damolog.controller;

/**
 * 
 * Observer für das Modell
 * 
 * @author nsmeenk
 * 
 */
public interface IObserver {

	/**
	 * Wird ausgeführt, wenn das beobachtete Objekt sich ändert
	 * 
	 * @param pChanged
	 *            Objekt welches sich geändert hat
	 */
	public void update(Object pChanged);

}
