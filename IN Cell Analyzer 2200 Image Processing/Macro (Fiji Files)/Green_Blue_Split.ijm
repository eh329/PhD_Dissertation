#@File merged_folder = (label = "Folder containing merged images", style = "directory");

function splitting () {
	run("Close All");
	print("\\Clear");
	split_folder = File.getParent(merged_folder) + File.separator + "Green_Blue_split";
	File.makeDirectory(split_folder);
	merged_images = getFileList(merged_folder);
	
	for (i = 0; i < lengthOf(merged_images); i++) {
		if (endsWith(merged_images[i], "tif")); {

			merger_name = merged_images[i];
			open(merged_folder + File.separator + merger_name);
			run("Split Channels");

			selectWindow(merger_name + " (green)");
			run("Green");
			saveAs("tif", split_folder + File.separator + merger_name + " (green)");
			close();
			selectWindow(merger_name + " (red)");
			close();
			selectWindow(merger_name +" (blue)");
			run("Blue");
			saveAs("tif", split_folder + File.separator + merger_name + " (blue)");
			close();
		}
	} 
}





splitting()