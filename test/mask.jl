using Images
using ImageIO
using VideoIO

# Load image from the video
vid = VideoIO.load("wave_animation3.mp4")

# Function to apply the mask
function mask_image(img, img2)
    alpha_mask1 = map(x -> x.alpha, img)

    # Check if dimensions of img2 are larger or equal to img
    if size(img2)[1] >= size(img)[1] && size(img2)[2] >= size(img)[2]
        
        # Calculate starting positions for x and y coordinates to center the logo
        start_x = round(Int, (size(img2)[1] - size(img)[1]) / 2)
        start_y = round(Int, (size(img2)[2] - size(img)[2]) / 2)

        # Create a new image from img with the same size as img2
        new_img = deepcopy(img2)

        # Iterate through the pixels of img
        for i in 1:size(img)[1]
            for j in 1:size(img)[2]
                alpha = alpha_mask1[i, j]
                # Replace non-transparent pixels of img with the colors of img2
                if alpha > 0
                    new_img[start_x + i, start_y + j] = img2[start_x + i, start_y + j] + RGBA(0, 0, 0, 0) * (1 - alpha)
                else
                    new_img[start_x + i, start_y + j] = img[i, j]
                end
            end
        end
        
        return new_img
    else
        println("The dimensions of img2 are smaller than those of img. To perform the operation, img2 must be larger or equal in dimensions.")
        return nothing
    end
end

# Load the RGBA image from PNG
img = load("data/openai.png")

# Create a vector to store the masked frames
masked_frames = Vector{typeof(img)}(undef, length(vid))

# Apply the masking effect to each frame of the video
for (i, frame) in enumerate(vid)
    masked_frames[i] = mask_image(img, frame)
end