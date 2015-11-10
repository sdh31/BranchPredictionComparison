import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.File;
import java.util.List;
import java.util.ArrayList;


/* From command line, run
        1) javac TwoLevelDataGatherer.java
        2) java TwoLevelDataGatherer ../2LevelData/[benchmark_name]/
*/

public class TwoLevelDataGatherer {

	private static final String TWO_LEVEL_DATA_FILE = "TwoLevelData.csv";

	public List<DataLine> gatherDataFromFolder(String folderName) {
		List<DataLine> dataLines = new ArrayList<DataLine>();
		File folder = new File(folderName);
		File[] files = folder.listFiles();

		for (File file : files) {
			if (file.isFile() && file.getName().contains(("2lev"))) {
				dataLines.add(gatherFileData(file, folder.getName()));
			}
		}
		return dataLines;
	}

	private DataLine gatherFileData(File file, String benchmark) {
		String absoluteFilePath = file.getAbsolutePath();
		String fileName = file.getName();
		/* removes file extension */
		fileName = fileName.substring(0, fileName.lastIndexOf('.'));

		String instructionCount = "";
		String bPredMisses = "";

		try {
			BufferedReader br = new BufferedReader(new FileReader(absoluteFilePath));
			StringBuilder sb = new StringBuilder();
   			String line = br.readLine();
    		while (line != null) {
    			if (line.contains("sim_num_insn")) {
					String[] splits = line.split("\\s+");
					instructionCount = splits[1];
    			}
    			if (line.contains("bpred_2lev.misses")) {
					String[] splits = line.split("\\s+");
					bPredMisses = splits[1];
    			}
        		line = br.readLine();
    		}
		} catch (IOException e) { }
		DataLine dataLine= new DataLine(benchmark, fileName, bPredMisses, instructionCount);
		return dataLine;
	}

	private void writeDataToFile(List<DataLine> dataLines) {
		try {
			File fileOut = new File(TWO_LEVEL_DATA_FILE);
			fileOut.createNewFile();
			BufferedWriter writer = new BufferedWriter(new FileWriter(fileOut.getName(), true));
			for (DataLine dataLine : dataLines) {
				String lineOut = dataLine.benchmark + "," + dataLine.config + "," +
						dataLine.bPredMisses + "," + dataLine.numInstructions;
				writer.write(lineOut);
				writer.newLine();
			}
			writer.flush();
		} catch (IOException e) { }
	}

	private class DataLine {
		private String benchmark;
		private String config;
		private String bPredMisses;
		private String numInstructions;

		public DataLine(String benchmark, String config, String bPredMisses, String numInstructions) {
			this.benchmark = benchmark;
			this.config = config;
			this.bPredMisses = bPredMisses;
			this.numInstructions = numInstructions;
		}
	}

	public static void main (String [] args) {
		TwoLevelDataGatherer gatherer = new TwoLevelDataGatherer();
		List<DataLine> dataLines = gatherer.gatherDataFromFolder(args[0]);
		gatherer.writeDataToFile(dataLines);
	}

}