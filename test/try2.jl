using Images
using OpenAIReplMode

background = fill(RGBA(1,1,1,1), 1080, 1920)
image1 = load("data/openai.png")

height, width = size(image1)
white_image = fill(RGBA(1,1,1,1), height, width) # create a white image of the same size as image1
for x = 1:width, y = 1:height
    if image1[y,x].alpha != 0
        white_image[y,x] = image1[y,x]
    end
end

scale_factor = 3
w, h = width*scale_factor, height*scale_factor
image_scaled = imresize(white_image, (h,w)) # scale the image by 3 times

xc = div(1920-w, 2)
yc = div(1080-h-300, 2)  # raise the image by 300 pixels
background[yc:yc+h-1, xc:xc+w-1, :] = image_scaled
display(background)