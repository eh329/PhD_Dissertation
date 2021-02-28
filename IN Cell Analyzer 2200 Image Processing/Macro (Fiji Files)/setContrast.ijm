#@File contrast_folder = (label = "Folder with images", style = "directory");

function setContrast() {
	// Creating a new folder with Contrast_ + the name of the older folder
	new_folder = "Contrast_" + substring(contrast_folder, lastIndexOf(contrast_folder, "\\") + 1, lengthOf(contrast_folder));
	contrasted = File.getParent(contrast_folder) + File.separator + new_folder;

	// Adding this new folder in the same directory with old folder
	File.makeDirectory(contrasted);
	no_contrast_images = getFileList(contrast_folder);

	// Taking two numbers as inputs for setting minimum and maximum contrast numbers
	min = getNumber("Number for minimum contrast", 0);
	max = getNumber("Number for maximum contrast", 0);

	// Looping through the old folder images
	for (i = 0; i < lengthOf(no_contrast_images); i++) {

		// Opening each single image in the old folder
		images_name = no_contrast_images[i];
		open(contrast_folder + File.separator + images_name);

		// Running "Brightness/Contrast" and setting the minimum and maximum numbers for the contrast 
		//run("Brightness/Contrast...");
		selectImage(images_name);
		setMinAndMax(min, max);
		//run("Apply LUT");

		// Saving the image with the new contrast in the new folder and close the image
		saveAs("tif", contrasted + File.separator + images_name);
		run("Close");
	}
}

setContrast()



