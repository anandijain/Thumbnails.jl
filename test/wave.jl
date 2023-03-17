using Images, Colors
  
# Set the dimensions of the animation frame
img_width = 512
img_height = 512

# Set the total number of frames and the frame rate
num_frames = 60
frame_rate = 30
frame_duration = 1 / frame_rate

# Set the speed of the waves, in pixels per second
wave_speed = 150

# Set the amplitude and frequency of the waves
wave_amplitude = 50
wave_frequency = 0.02

# Set the color of the waves
wave_color = RGB(0.2, 0.6, 0.8)

# Set the color of the background
bg_color = RGB(0.1, 0.1, 0.1)

# Set up the output image matrix
output_image = zeros(RGB{Float64}, img_height, img_width)

# Define the function for generating each animation frame
function generate_frame(output_image::Matrix{RGB{Float64}}, i::Int)
    # Calculate the position of the waves at the current frame
    x_range = 1:img_width
    y_range = 1:img_height
    x_positions = [x + wave_amplitude * sin(wave_frequency * (x - wave_speed * i * frame_duration)) for x in x_range]
    y_positions = [y + wave_amplitude * cos(wave_frequency * (y - wave_speed * i * frame_duration)) for y in y_range]
    # Set the color of each pixel in the output image matrix
    for x in x_range
        for y in y_range
            output_image[y, x] = bg_color
            # Check if the current pixel is within the bounds of the waves
            if (x - x_positions[x])^2 + (y - y_positions[y])^2 <= wave_amplitude^2
                output_image[y, x] = wave_color
            end
        end
    end
    # Return the output image matrix
    output_image
end

# Generate and save each animation frame
for i in 1:num_frames
    frame_filename = "wave_anim_$(i).png"
    generate_frame(output_image, i)
    save(frame_filename, output_image)
end

# Convert the PNG frames to an MP4 video using ffmpeg
run(`ffmpeg -r $frame_rate -f image2 -s $(img_width)x$(img_height) -i wave_anim_%d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p wave_animation.mp4`)

# Delete the PNG frames
for i in 1:num_frames
    frame_filename = "wave_anim_$(i).png"
    rm(frame_filename)
end
