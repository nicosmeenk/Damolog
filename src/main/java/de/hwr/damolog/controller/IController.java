package de.hwr.damolog.controller;

import java.util.List;

import de.hwr.damolog.model.Checker;
import de.hwr.damolog.model.Model;
import de.hwr.damolog.model.Point;

/**
 * 
 * Interface um einen Controller zu definieren
 * 
 * @author nsmeenk
 * 
 */
public interface IController {

	/**
	 * Setzt das Modell
	 * 
	 * @param pModel
	 */
	public void setModel(Model pModel);

	/**
	 * gibt eine Liste der Figuren zurück, die gesetzt werden können
	 * 
	 * @return Liste der setzbaren Figuren
	 */
	public List<Checker> getPossibleFiguresToJump();

	/**
	 * Gibt eine Liste der möglichen orte an, an die eine Figur gesetzt werden
	 * kann
	 * 
	 * @param pFigure
	 *            Figur von der die Orte angegeben werden sollen
	 * @return Ote an die die Figur gehen kann
	 */
	public List<Point> getPossiblePontsToGoWith(Checker pFigure);

}
