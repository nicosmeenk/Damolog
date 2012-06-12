package dev;

import gnu.prolog.database.PrologTextLoaderError;
import gnu.prolog.io.TermWriter;
import gnu.prolog.term.AtomTerm;
import gnu.prolog.term.CompoundTerm;
import gnu.prolog.term.CompoundTermTag;
import gnu.prolog.term.IntegerTerm;
import gnu.prolog.term.Term;
import gnu.prolog.term.VariableTerm;
import gnu.prolog.vm.Environment;
import gnu.prolog.vm.Interpreter;
import gnu.prolog.vm.Interpreter.Goal;
import gnu.prolog.vm.PrologCode;

import java.util.List;

public class Tester {

	private static void debug(Environment env) {
		List<PrologTextLoaderError> errors = env.getLoadingErrors();
		for (PrologTextLoaderError error : errors) {
			error.printStackTrace();
		}
	}

	private static void loadTests() throws Exception {
		Environment environment = new Environment();
		environment.ensureLoaded(AtomTerm.get(Tester.class.getClassLoader()
				.getResource("dev/alphabeta.pl").getFile()));
		environment.ensureLoaded(AtomTerm.get(Tester.class.getClassLoader()
				.getResource("dev/abc.pl").getFile()));

		Interpreter interpreter = environment.createInterpreter();
		environment.runInitialization(interpreter);

		VariableTerm variableTerm = new VariableTerm("W");
		Term[] params= {variableTerm};
		CompoundTerm goalTerm = new CompoundTerm(AtomTerm.get("qq"), params);
		debug(environment);
		
//		int rc = interpreter.runOnce(goalTerm);
		
		Goal goal = interpreter.prepareGoal(goalTerm);
		int rc;
		do {
			rc = interpreter.execute(goal);
			System.out.println(rc);
			System.out.println(variableTerm.dereference());
			
		} while (rc == PrologCode.SUCCESS && rc != PrologCode.SUCCESS_LAST);

	}

	public static void main(String[] args) {
		try {
			loadTests();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
