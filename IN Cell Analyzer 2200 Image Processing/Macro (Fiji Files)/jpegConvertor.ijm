#@File tif_folder = (label = "Folder with tif images", style = "directory");


run("Close All");
print("\\Clear");
jpeg_folder = File.getParent(tif_folder) + File.separator + "jpeg_folder";
File.makeDirectory(jpeg_folder);
tif_images = getFileList(tif_folder);

for (i = 0; i < lengthOf(tif_images); i ++) {
	if (endsWith (tif_images[i] ,".tif")) {
		
		tif_name = tif_images[i];
		open(tif_folder + File.separator + tif_name);
		run("Input/Output...", "jpeg=100 gif=-1 file=.txt save_column save_row");
		run("32-bit");
		
		selectImage(tif_name);
		saveAs("Jpeg", jpeg_folder + File.separator + tif_name);
		print("Converting -" + tif_name + "- to jpeg...");
		print("Done!");
		close();
	}
}


