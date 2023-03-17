
using Images
using ImageIO
using VideoIO

# Load image from the first frame of the video
vid = VideoIO.load("wave_animation3.mp4")
img2 = vid[1]

# Load the RGBA image from PNG
img = load("data/openai.png")
alpha_mask1 = map(x -> x.alpha, img)

# Check if dimensions of img2 are larger or equal to img
if size(img2)[1] >= size(img)[1] && size(img2)[2] >= size(img)[2]
    
    # Create a new image from img with the same size as img
    new_img = similar(img)

    # Iterate through the pixels of img
    for i in 1:size(img)[1]
        for j in 1:size(img)[2]
            alpha = alpha_mask1[i, j]
            # Replace non-transparent pixels of img with the colors of img2
            if alpha > 0
                new_img[i, j] = img2[i, j] + RGBA(0, 0, 0, 0) * (1 - alpha)
            else
                new_img[i, j] = img[i, j]
            end
        end
    end

    # Save the resulting image
    save("output_image.png", new_img)

else
    println("The dimensions of img2 are smaller than those of img. To perform the operation, img2 must be larger or equal in dimensions.")
end