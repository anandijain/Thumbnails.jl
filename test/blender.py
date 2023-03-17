import bpy

# create a new camera and add it to the scene
camera_data = bpy.data.cameras.new(name="Camera")
camera_obj = bpy.data.objects.new(name="Camera", object_data=camera_data)
bpy.context.scene.camera = camera_obj
bpy.context.collection.objects.link(camera_obj)
bpy.ops.object.camera_add()


# load the images and create the objects
image1_path = "data/arm.png"
image2_path = "data/openai.svg"
bpy.ops.image.open(filepath=image1_path)
bpy.ops.image.open(filepath=image2_path)

# create the objects
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
image1 = bpy.data.images[0]
image2 = bpy.data.images[1]
image1_obj = bpy.data.objects.new(name="Image1", object_data=None)
image2_obj = bpy.data.objects.new(name="Image2", object_data=None)
bpy.context.collection.objects.link(image1_obj)
bpy.context.collection.objects.link(image2_obj)
image1_obj.data = image1
image2_obj.data = image2

# position the objects
image1_obj.location = (0, 0, 0)
image2_obj.location = (image1.size[0] / 2, 0, 0)
image2_obj.rotation_euler = (0, 0, 180)

# render the image
bpy.context.scene.render.filepath = "data/output.png"
bpy.ops.render.render(write_still=True)
