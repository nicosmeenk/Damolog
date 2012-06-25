package de.hwr.damolog.controller.implementation;

import java.util.List;

import de.hwr.damolog.controller.IController;
import de.hwr.damolog.model.Checker;
import de.hwr.damolog.model.Model;
import de.hwr.damolog.model.Point;

/**
 * 
 * Controller für die Prolog Logik
 * 
 * @author nsmeenk
 * 
 */
public class PrologController implements IController {

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * de.hwr.damolog.controller.IController#setModel(de.hwr.damolog.model.Model
	 * )
	 */
	@Override
	public void setModel(Model pModel) {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see de.hwr.damolog.controller.IController#getPossibleFiguresToJump()
	 */
	@Override
	public List<Checker> getPossibleFiguresToJump() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * de.hwr.damolog.controller.IController#getPossiblePontsToGoWith(de.hwr
	 * .damolog.model.Figure)
	 */
	@Override
	public List<Point> getPossiblePontsToGoWith(Checker pFigure) {
		// TODO Auto-generated method stub
		return null;
	}

}
