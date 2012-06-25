/**
 * 
 */
package de.hwr.damolog.view;

import de.hwr.damolog.controller.IController;
import de.hwr.damolog.controller.IObserver;

/**
 * 
 * Eine View die Subjekte beobachten kann
 * 
 * @author nsmeenk
 * 
 */
public interface IObservingView extends IObserver {

	/**
	 * Setzt den Controller
	 * 
	 * @param pController
	 */
	public void setController(IController pController);

}
