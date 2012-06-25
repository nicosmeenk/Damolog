package de.hwr.damolog.controller;

/**
 * 
 * Observer f�r das Modell
 * 
 * @author nsmeenk
 * 
 */
public interface IObserver {

	/**
	 * Wird ausgef�hrt, wenn das beobachtete Objekt sich �ndert
	 * 
	 * @param pChanged
	 *            Objekt welches sich ge�ndert hat
	 */
	public void update(Object pChanged);

}
