from PIL import Image, ImageDraw, ImageOps
import cairosvg

# Read the SVG image and save it as a PNG image
# cairosvg.svg2png(url='data/openai.svg', write_to='data/openai.png')
center_image = Image.open('data/openai.png')
right_image = Image.open('data/arm.png')

# Resize right image to match the height of the center image and desired width
desired_width = 800
height_ratio = float(desired_width) / right_image.size[0]
new_height = int(right_image.size[1] * height_ratio)
right_image = right_image.resize((desired_width, new_height), Image.ANTIALIAS)

# Create a new blank image with the desired width and height
new_image = Image.new('RGB', (2 * desired_width, new_height), (255, 255, 255))

# Calculate the horizontal position of each image
center_x = desired_width
right_x = 2 * desired_width - center_image.size[0]
left_x = 0

# Paste the first image in the center of the blank image
new_image.paste(center_image, (center_x - center_image.size[0] // 2, new_height // 2 - center_image.size[1] // 2))

# Remove the background from the second image using a threshold
mask = Image.new('1', (right_image.width + 2, right_image.height + 2), 0)
ImageDraw.floodfill(right_image, (0, 0), (255, 255, 255))
ImageDraw.floodfill(right_image, (right_image.width - 1, right_image.height - 1), (255, 255, 255))
right_image = ImageOps.invert(ImageOps.colorize(right_image, (0, 0, 0), (255, 255, 0))).convert('1')
right_image.putalpha(mask.crop((1, 1, right_image.width + 1, right_image.height + 1)))

# Paste the second image to the right of the first image in the blank image
new_image.paste(right_image, (right_x, new_height // 2 - right_image.size[1] // 2), mask=right_image)

# Create a copy of the second image and reflect it horizontally
reflected_image = ImageOps.mirror(right_image)

# Paste the reflected image to the left of the first image in the blank image
new_image.paste(reflected_image, (left_x, new_height // 2 - reflected_image.size[1] // 2), mask=reflected_image)

# Save the final image
new_image.save('output.png')