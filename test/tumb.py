from gimpfu import *

def add_images(image1, image2):
    width1 = image1.width
    height1 = image1.height
    width2 = image2.width
    height2 = image2.height
    new_width = width1 + width2
    new_height = max(height1, height2)
    
    # Copy image1 to new image and center it
    new_image = gimp.Image(new_width, new_height, RGB)
    drawable = new_image.active_layer
    floating_sel = pdb.gimp_edit_copy_visible(image1)
    pdb.gimp_floating_sel_anchor(floating_sel)
    offset_x = (new_width - width1) / 2
    offset_y = (new_height - height1) / 2
    pdb.gimp_layer_set_offsets(drawable, offset_x, offset_y)
    
    # Remove background from image2 and place it on the right side of the first image
    pdb.gimp_context_set_background((0, 0, 0))
    pdb.gimp_image_convert_rgb(image2)
    pdb.gimp_image_add_alpha(image2)
    pdb.gimp_selection_none(image2)
    pdb.plug_in_autocrop(image2, image2.active_layer)
    pdb.gimp_edit_clear(image2.active_layer)
    floating_sel = pdb.gimp_edit_copy_visible(image2)
    pdb.gimp_floating_sel_anchor(floating_sel)
    offset_x = (new_width - width2) / 2 + width1
    offset_y = (new_height - height2) / 2
    pdb.gimp_layer_set_offsets(drawable, offset_x, offset_y)
    
    # Create a horizontally reflected copy of image2 and place it on the left side of the first image
    reflection = pdb.gimp_layer_copy(image2.active_layer, True)
    pdb.gimp_item_set_name(reflection, "Reflection")
    pdb.gimp_layer_set_mode(reflection, LAYER_MODE_NORMAL)
    pdb.gimp_image_insert_layer(new_image, reflection, None, 0)
    offset_x = (width1 - width2) / 2
    offset_y = (new_height - height2) / 2
    pdb.gimp_layer_set_offsets(reflection, offset_x, offset_y)
    pdb.gimp_layer_transform_reflection(reflection, True, True)
  
    # Show the final image
    gimp.Display(new_image)

# Register the plugin with GIMP
register(
    "python_fu_add_images",
    "Add two images together",
    "Adds the first image centered with the second image attached to the right side and a horizontally reflected copy of the second image on the left side.",
    "Your Name",
    "Your Name",
    "2023",
    "<Image>/Filters/Add Images...",
    "*",
    [
        (PF_IMAGE, "image1", "Image 1", None),
        (PF_IMAGE, "image2", "Image 2", None)
    ],
    [],
    add_images)

main()
