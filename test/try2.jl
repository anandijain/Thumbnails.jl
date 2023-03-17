using Images
using OpenAIReplMode

background_image = load("data/bg.png")
background_scaled = imresize(background_image, (1080,1920))

image1 = load("data/openai.png")

height, width = size(image1)
white_image = fill(RGBA(1,1,1,0), height, width) # create a transparent image of the same size as image1
for x = 1:width, y = 1:height
    if image1[y,x].alpha != 0
        white_image[y,x] = RGBA(1-image1[y,x].r, 1-image1[y,x].g, 1-image1[y,x].b, image1[y,x].alpha) # invert the color channels
    end
end

scale_factor = 6
w, h = width*scale_factor, height*scale_factor
image_scaled = imresize(white_image, (h,w)) # scale the image by 6 times

raise_amount = 0
yc = div(1080-h-raise_amount, 2)  # raise the image by raise_amount pixels

# blend the two images using the alpha values of the image_scaled image
for x = 1:w, y = 1:h
    pixel = image_scaled[y,x]
    alpha = pixel.alpha
    if (yc+y) <= 1080 && (xc+x) <= 1920 && alpha > 0
        # blend the images at this location based on the alpha value
        background_scaled[yc+y, xc+x, :] = alpha.*pixel .+ (1-alpha).*background_scaled[yc+y, xc+x, :]
    end
end

display(background_scaled)
