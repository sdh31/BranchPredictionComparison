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
		// keep this at top level folder, ./2LevelData/
		File[] benchmarkFolders = folder.listFiles();

		for (File benchmarkFolder : benchmarkFolders) {
			if (benchmarkFolder.isDirectory()) {
				File [] files = benchmarkFolder.listFiles();
				for (File file : files) {
					if (file.isFile() && file.getName().contains(("2lev"))) {
						dataLines.add(gatherFileData(file, benchmarkFolder.getName()));
					}
				}
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
				if (line.contains("bpred:2lev") && line.contains("(<l1size> <l2size> <hist_size> <xor>)")) {
					ensureCorrectFileConfig(line, file);
				}
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

	private void ensureCorrectFileConfig(String line, File file) {
		String [] config = line.split("\\s+");
		String l1Size = config[1];
		String l2Size = config[2];
		String histSize = config[3];
		String xor = config[4];

		// fileName looks like twolf_2lev_1_16_4_0.txt
		String fileName = file.getName();
		String [] fileNameConfig = fileName.split("_");

		if (!fileNameConfig[2].equals(l1Size)) {
			System.out.println("L1 size is incorrect for file: " + fileName);
		}
		if (!fileNameConfig[3].equals(l2Size)) {
			System.out.println("L2 size is incorrect for file: " + fileName);
		}
		if (!fileNameConfig[4].equals(histSize)) {
			System.out.println("History size is incorrect for file: " + fileName);
		}
		if (!fileNameConfig[5].substring(0, fileNameConfig[5].lastIndexOf('.')).equals(xor)) {
			System.out.println("XOR argument is incorrect for file: " + fileName);
		}
	}

	private void writeDataToFile(List<DataLine> dataLines) {
		try {
			File fileOut = new File(TWO_LEVEL_DATA_FILE);
			fileOut.createNewFile();
			BufferedWriter writer = new BufferedWriter(new FileWriter(fileOut.getName(), false));
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