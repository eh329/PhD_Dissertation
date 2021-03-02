// Separate DAPI images and FITC images in two different folders
// Giving the addresses of the two folders 
#@File dapi_folder = (label = "Folder with DAPI images", style = "directory");
#@File fitc_folder = (label = "Folder with FITC images", style = "directory");



function merging () {
	run("Close All");
	print("\\Clear");

	// Creating a new folder to save the new images in
	merged_folder = File.getParent(dapi_folder) + File.separator + "Green_Blue_merged";
	File.makeDirectory(merged_folder);
	dapi_images = getFileList(dapi_folder);
	ftc_images = getFileList(fitc_folder);

	// Loop through one of the folders.
	for (i = 0; i < lengthOf(dapi_images); i++) {
		if (endsWith (dapi_images[i], ".tif")) {
		
			dapi_name = dapi_images[i];
			ftc_name = ftc_images[i];
			open(dapi_folder + File.separator + dapi_name);
			open(fitc_folder + File.separator + ftc_name);
			// Add FITC to the second channel that is for green color and DAPI to third channel thath is for blue color.
			run("Merge Channels...", "c2=["+ftc_name+"] c3=["+dapi_name+"] create");
			// Select the new image
			selectImage("Composite");
			// Give it a new name
			final_name = substring( dapi_name, 0, lastIndexOf( dapi_name, "wv" ) -1 ) +")";
			print(final_name);
			run("RGB Color");
			selectWindow("Composite");
			close();
			selectWindow("Composite (RGB)");
			// Save it
			saveAs("tif", merged_folder + File.separator + final_name);
			selectWindow(final_name + ".tif");
			close();
		}
	}
}




merging()