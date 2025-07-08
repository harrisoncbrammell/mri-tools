function normImg = normClamp(image,low,high) %%returns a normalized image clamped at low and high parameters
    normImg = double(image);
    normImg(normImg < low) = low;
    normImg(normImg > high | isinf(normImg)) = high;
    normImg = (normImg - low)/(high-low);
   return;
end