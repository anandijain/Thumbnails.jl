from PIL import ImageOps, ImageDraw, Image
import cairosvg

cairosvg.svg2png(url='data/openai.svg', write_to='data/openai.png')

center_image = Image.open('data/openai.png')
right_image = Image.open('data/arm.png')

right_image_gray = right_image.convert('L')
right_image_inverted = ImageOps.invert(right_image_gray)
right_image_colorized = ImageOps.colorize(right_image_inverted, (0, 0, 0), (255, 255, 0))
right_image_resized = right_image_colorized.convert('1')

desired_width = 800
height_ratio = float(desired_width) / right_image.size[0]
new_height = int(right_image.size[1] * height_ratio)
right_image_resized = right_image_resized.resize((desired_width, new_height), Image.ANTIALIAS)

new_image = Image.new('RGB', (2 * desired_width, new_height), (255, 255, 255))

center_x = desired_width
right_x = 2 * desired_width - center_image.size[0]
left_x = 0

new_image.paste(center_image, (center_x - center_image.size[0] // 2, new_height // 2 - center_image.size[1] // 2))

mask = Image.new('1', (right_image_resized.width + 2, right_image_resized.height + 2), 0)
pixels = right_image_resized.load()

# Iterate over all pixels of the image and set the white pixels to black and the black pixels to white
for i in range(right_image_resized.width):
    for j in range(right_image_resized.height):
        if pixels[i, j] == 0:
            pixels[i, j] = 255
        else:
            pixels[i, j] = 0

# Convert the 1-bit mask to an 8-bit grayscale image in 'L' mode
mask_colorized = ImageOps.colorize(mask.crop((1, 1, right_image_resized.width + 1, right_image_resized.height + 1)), (0, 0, 0), (255, 255, 255))
mask_gray = mask_colorized.convert('L')

# Paste the second image to the right of the first image in the blank image
right_image_resized.putalpha(mask_gray)
new_image.paste(right_image_resized, (right_x, new_height // 2 - right_image_resized.size[1] // 2), mask=right_image_resized)

reflected_image = ImageOps.mirror(right_image_resized)

new_image.paste(reflected_image, (left_x, new_height // 2 - reflected_image.size[1] // 2), mask=reflected_image)

new_image.save('output.png')
