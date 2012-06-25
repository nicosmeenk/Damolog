package de.hwr.damolog;

import de.hwr.damolog.controller.IController;
import de.hwr.damolog.controller.implementation.PrologController;
import de.hwr.damolog.model.Model;
import de.hwr.damolog.view.IObservingView;
import de.hwr.damolog.view.implementation.SwtMainWindow;

/**
 * 
 * In dieser Klasse wird das Programm gestartet.
 * 
 * @author nsmeenk
 * 
 */
public class Starter {

	public static void main(String[] args) {

		// MVC
		Model model = new Model();

		IController controller = new PrologController();
		controller.setModel(model);

		IObservingView view = new SwtMainWindow();
		view.setController(controller);

		// Observer Design Pattern
		model.addObserver(view);

	}

}
