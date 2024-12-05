
allowed_chars = ["M", "S"]

function checkMas(matrix, startx, starty)
    if startx - 1 < 1 || starty - 1 < 1 || startx + 1 > length(matrix[1]) || starty + 1 > length(matrix)
        return false
    end

    corners = []

    for dy in range(-1, 1, 2)
        for dx in range(-1, 1, 2)
            push!(corners, matrix[Int(starty + dy)][Int(startx + dx)])
        end
    end

    for corner in corners
        if !(corner in allowed_chars)
            return false
        end
    end

    return (corners[1] != corners[4]) && (corners[2] != corners[3])
end

function main()
    f = open("in.q2.txt", "r")

    matrix = []

    for line in eachline(f)
        push!(matrix, split(line, ""))
    end

    xmasCount = 0

    for starty in eachindex(matrix)
        for startx in eachindex(matrix[starty])
            if matrix[starty][startx] == "A"
                if checkMas(matrix, startx, starty)
                    xmasCount += 1
                end
            end
        end
    end

    println(xmasCount)

    close(f)

end

main()